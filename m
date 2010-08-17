Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0HQGAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:00:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56622 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0HQGAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G8gfznVZ66FWLg5qIL+/Y4yPQnHu2Bqsg/2qkzEok9IqB6EtV/a4WhB2My+RO2i+bP
         m50JG17zweY8DVk0BOyvh8dGVae7YqEhysuVNk1JwTwr3fLeCCfTTFxIttUG+KzfuKIa
         YpIzTFh1xp8Qim48wZHZFrkPBIrT7iSzvzo3M=
Subject: Re: BUG: IPv6 stops working after a while, needs ip ne del command
 to reset
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Habets <thomas@habets.pp.se>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1008170719180.21857@red.crap.retrofitta.se>
References: <alpine.DEB.1.10.1008131952470.19570@red.crap.retrofitta.se>
	 <1281953960.2524.23.camel@edumazet-laptop>
	 <alpine.DEB.1.10.1008161224510.13728@red.crap.retrofitta.se>
	 <alpine.DEB.1.10.1008170719180.21857@red.crap.retrofitta.se>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 08:00:02 +0200
Message-ID: <1282024802.2487.687.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 août 2010 à 07:35 +0200, Thomas Habets a écrit :
> On Mon, 16 Aug 2010, Thomas Habets wrote:
> > Am I not allowed to add addresses to lo? That I've deconfigured this address 
> > and rebooted the box to check if this matters.
> 
> It didn't help.
> 
> > I will re-check ethtool and Cisco router output for mismatches when it breaks 
> > again to make sure that there's no change or errors counting up.
> 
> IPv6 is currently not working and it's still 1000 Full on both sides 
> ("show int GiX/Y" and "ethtool eth0").
> No errors in "ethtool -S eth0" or "show int GiX/Y".
> 
> "ethtool eth0" output is the same as yesterday.
> 
> Here's the addresses and routing table as they are now, and have been 
> since reboot:
> 
> $ ip -6 a
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436
>      inet6 ::1/128 scope host
>         valid_lft forever preferred_lft forever
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qlen 1000
>      inet6 2a00:800:752:1::5c:2/112 scope global
>         valid_lft forever preferred_lft forever
>      inet6 fe80::224:81ff:fea3:4424/64 scope link
>         valid_lft forever preferred_lft forever
> 
> 
> $ ip -6 r sh
> 2a00:800:752:1::5c:0/112 dev eth0  proto kernel  metric 256  mtu 1500
> advmss 1440 hoplimit 4294967295
> 
> fe80::/64 dev eth0  proto kernel  metric 256  mtu 1500 advmss 1440
> hoplimit 4294967295
> 
> default via 2a00:800:752:1::5c:1 dev eth0  metric 1024  mtu 1500 advmss
> 1440 hoplimit 4294967295
> 
> $ ip -6 ne sh
> 2a00:800:752:1::5c:1 dev eth0 lladdr 00:22:55:17:4b:80 router STALE
> 
> [try ping6 again, no reply]
> 
> $ ip -6 ne sh
> 2a00:800:752:1::5c:1 dev eth0 lladdr 00:22:55:17:4b:80 router DELAY
> 
> [try ping6 again, no reply]
> 
> $ ip -6 ne sh
> 2a00:800:752:1::5c:1 dev eth0 lladdr 00:22:55:17:4b:80 router REACHABLE
> 

This seems a bit different than previous mail. Apparently discovery now
works ?

Could you have a tcpdump on both sides ?

Maybe your host is OK, but other side drops your ICMP packets ?

> [try ping6 again, no reply]
> 
> Configured network with /etc/network/interfaces:
> 
> auto lo
> iface lo inet loopback
> 
> allow-hotplug eth0
> iface eth0 inet static
>  	address x.x.x.x
>  	netmask 255.255.255.252
>  	broadcast x.x.x.x
>  	gateway x.x.x.x
>  	up ip a a 2a00:800:752:1::5c:2/112 dev eth0
>  	up ip r a default via 2a00:800:752:1::5c:1
>  	dns-nameservers x.x.x.x
>  	dns-search xxxx.net


