Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab1CXWTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:19:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56389 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab1CXWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CKEe62eAzalNp7ZaNpTbt03Rh47aJa+OhPX4ybIV6iuyURbNEfwfiboAuGnc2Ro/kZ
         q8Ufqheeq4UrV39ceyn/JQvR0cQa7LJW/ipgi0ajV/iIpRUlSVI6v/0KszKLRXUZ3SW4
         vo0EMgmJxB/mzwCOc82Rqt3MxX2FIUJF9WLAE=
Subject: Re: [PATCH] ipv4: fix fib metrics
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTin_gxMF1hyK_yhN+G9UGfcBKAhPE24r7tLe5j3D@mail.gmail.com>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
	 <1300980118.3747.42.camel@edumazet-laptop>
	 <AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
	 <1300983340.3747.44.camel@edumazet-laptop>
	 <1300986084.3747.101.camel@edumazet-laptop>
	 <AANLkTik+Rf45wUxN86t+Zp7+AXjcJsy0vmZgvmLj-95x@mail.gmail.com>
	 <1300992308.3747.205.camel@edumazet-laptop>
	 <AANLkTin_gxMF1hyK_yhN+G9UGfcBKAhPE24r7tLe5j3D@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 23:18:27 +0100
Message-ID: <1301005107.2714.113.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 23:11 +0100, Alessandro Suardi a écrit :

> On a -git14 kernel + both the fib metrics and the above git diff, I
> strace'd vpnc
>  and found out this (first triplet of public IP masked intentionally)
> 
> [root@duff tmp]# egrep 'execve|garbage' strace.log |egrep '/ip|garbage'
> [pid  4228] execve("/sbin/ip", ["/sbin/ip", "route", "get",
> "xxx.9.13.212"], [/* 32 vars */]) = 0
> [pid  4231] execve("/sbin/ip", ["/sbin/ip", "route", "replace",
> "10.175.0.0/19", "dev", "tun0"], [/* 32 vars */]) = 0
> [pid  4232] execve("/sbin/ip", ["/sbin/ip", "route", "flush",
> "cache"], [/* 32 vars */]) = 0
> [pid  4234] execve("/sbin/ip", ["/sbin/ip", "route", "get",
> "xxx.9.13.212"], [/* 32 vars */]) = 0
> [pid  4237] execve("/sbin/ip", ["/sbin/ip", "route", "add",
> "xxx.9.13.212", "via", "192.168.1.1", "dev", "eth1", "src",
> "192.168.1.8", "ipid", "0x043f", "advmss", "1400"], [/* 32 vars */]) =
> 0
> [pid  4237] write(2, "Error: either \"to\" is duplicate,"..., 57Error:
> either "to" is duplicate, or "ipid" is a garbage.
> 
> 192.168.1.1 is my DSL router and 192.168.1.8 is my computer's wireless IP.
> 
> Does this ring any bell ?
> 
> 

Not a kernel error, but a tool error ?


(ipid is only displayed by "ip ro show")

grep ipid */*.c
ip/iproute.c:				fprintf(fp, " ipid 0x%04x", ci->rta_id);


