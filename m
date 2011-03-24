Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab1CXW1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:27:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58484 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab1CXW1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:27:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IgAGtRrstTBEIm6bBw7Ng2nGAfnWici/xX7S7wyNtPSrT7ja5PW6aIArhysilV7Sap
         TLhM4gVyoHkblqj3Y5Bs3gqxIQ+Nta7WsNsSLFAL0ZKihNSOT9cZ0B/NSXjbPx2pxDlL
         USM0I90aZF0NmNCU7SGDsQ6SNzJqcN4UzxwLo=
MIME-Version: 1.0
In-Reply-To: <1301005107.2714.113.camel@edumazet-laptop>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
	<1300980118.3747.42.camel@edumazet-laptop>
	<AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
	<1300983340.3747.44.camel@edumazet-laptop>
	<1300986084.3747.101.camel@edumazet-laptop>
	<AANLkTik+Rf45wUxN86t+Zp7+AXjcJsy0vmZgvmLj-95x@mail.gmail.com>
	<1300992308.3747.205.camel@edumazet-laptop>
	<AANLkTin_gxMF1hyK_yhN+G9UGfcBKAhPE24r7tLe5j3D@mail.gmail.com>
	<1301005107.2714.113.camel@edumazet-laptop>
Date: Thu, 24 Mar 2011 23:27:01 +0100
Message-ID: <AANLkTinv+XGBjbFoK6vpyiDW6gBEBKFjUef+mCAMJU9i@mail.gmail.com>
Subject: Re: [PATCH] ipv4: fix fib metrics
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:18 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 24 mars 2011 à 23:11 +0100, Alessandro Suardi a écrit :
>
>> On a -git14 kernel + both the fib metrics and the above git diff, I
>> strace'd vpnc
>>  and found out this (first triplet of public IP masked intentionally)
>>
>> [root@duff tmp]# egrep 'execve|garbage' strace.log |egrep '/ip|garbage'
>> [pid  4228] execve("/sbin/ip", ["/sbin/ip", "route", "get",
>> "xxx.9.13.212"], [/* 32 vars */]) = 0
>> [pid  4231] execve("/sbin/ip", ["/sbin/ip", "route", "replace",
>> "10.175.0.0/19", "dev", "tun0"], [/* 32 vars */]) = 0
>> [pid  4232] execve("/sbin/ip", ["/sbin/ip", "route", "flush",
>> "cache"], [/* 32 vars */]) = 0
>> [pid  4234] execve("/sbin/ip", ["/sbin/ip", "route", "get",
>> "xxx.9.13.212"], [/* 32 vars */]) = 0
>> [pid  4237] execve("/sbin/ip", ["/sbin/ip", "route", "add",
>> "xxx.9.13.212", "via", "192.168.1.1", "dev", "eth1", "src",
>> "192.168.1.8", "ipid", "0x043f", "advmss", "1400"], [/* 32 vars */]) =
>> 0
>> [pid  4237] write(2, "Error: either \"to\" is duplicate,"..., 57Error:
>> either "to" is duplicate, or "ipid" is a garbage.
>>
>> 192.168.1.1 is my DSL router and 192.168.1.8 is my computer's wireless IP.
>>
>> Does this ring any bell ?
>>
>>
>
> Not a kernel error, but a tool error ?
>
>
> (ipid is only displayed by "ip ro show")
>
> grep ipid */*.c
> ip/iproute.c:                           fprintf(fp, " ipid 0x%04x", ci->rta_id);

Don't think so. This tool has been working since I built it (29 June 2010)
 and still works in -git2 :)

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
