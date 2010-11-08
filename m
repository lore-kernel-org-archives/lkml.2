Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0KHLCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:02:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33589 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0KHLCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:02:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=W1zrfEz9vrnNRxF3QAzlJfxwpMA6X+lwdiP7YzfqjhIsxbcM0oQw0Koxqbh8xAer9C
         GeQ2gr4qSg4EOgSU5fzBLLhVqvUZOxPrxxJahfDtjS3AcLiOsqGVxnAqdqKDDB9orr2b
         X/EZ3YWdU2tnTf8agWNLg2mPRWQIbyLqpnj/0=
Subject: Re: OOM when adding ipv6 route:  How to make available more
 per-cpu memory?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: NetDev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
In-Reply-To: <4CD58B9C.2030006@candelatech.com>
References: <4CD43C87.5040403@candelatech.com>
	 <1288980361.2882.1070.camel@edumazet-laptop>
	 <4CD449A5.5070305@candelatech.com>
	 <1288988403.2665.268.camel@edumazet-laptop>
	 <1288995103.2665.653.camel@edumazet-laptop>
	 <4CD49C2F.3060904@candelatech.com>
	 <1289028392.2665.2418.camel@edumazet-laptop>
	 <4CD58B9C.2030006@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 12:02:11 +0100
Message-ID: <1289214131.2820.187.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 06 novembre 2010 à 10:08 -0700, Ben Greear a écrit :

> At least I don't see any percpu dumps in dmesg.  I vaguely remember
> someone posting some ipv6 address scalability patches some time back.
> I think they had to hack on /proc fs as well.  I'll see if I can
> dig those up.
> 
> > Make sure udev / hotplug is not the problem, if you create your devices
> > very fast.
> 
> We can create the macvlans w/out problem, though I'm sure that could
> be sped up.  The problem is when we try to add IPv6 addresses to
> them.

I see. Did you check /proc/sys/net/ipv6/ tunables ?

For example, I bet you need to make route/max_size a bigger value than
default (4096)

Following is working for me

echo 16384 >/proc/sys/net/ipv6/route/max_size
modprobe dummy numdummies=2000
for a in `seq 1 1999`
do
 ip -6 add add 4444::444:$a/24 dev dummy$a
done

ip -6 ro | wc -l
6008



