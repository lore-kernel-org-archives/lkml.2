Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758Ab1KCPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:16:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50363 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020Ab1KCPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:16:55 -0400
Message-ID: <1320333410.2344.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Route cache problem.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Thu, 03 Nov 2011 16:16:50 +0100
In-Reply-To: <20111103143734.GA17218@bitwizard.nl>
References: <20111103143734.GA17218@bitwizard.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 novembre 2011 à 15:37 +0100, Rogier Wolff a écrit :
> Hi, 
> 
> My workstation has an incorrect route cache entry: 
> 

What kernel version ?

> assurancetourix:~> route -nC | head -2 ; route -nC | grep 234.34
> Kernel IP routing cache
> Source          Destination     Gateway         Flags Metric Ref    Use Iface
> 192.168.235.8   192.168.234.34  192.168.235.251       0      0        3 eth0
> 192.168.235.8   192.168.234.34  192.168.235.251       0      0        4 eth0
> 192.168.235.8   192.168.234.34  192.168.235.251       0      0        2 eth0
> 
> (I don't know why there are three). 
> 

Different routing keys, like TOS.

for tos in `seq 2 2 34`; do ping -c 1 -Q $tos 10.37.168.112; done

# route -nC|grep 10.37.168.112
10.37.168.112   192.168.20.108  192.168.20.108  l     0      0      479 lo
192.168.20.108  10.37.168.112   192.168.20.254        0      0        3 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        3 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        3 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        3 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        3 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        5 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        5 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        5 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        1 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        1 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      0        0 eth3
192.168.20.108  10.37.168.112   192.168.20.254        0      1        2 eth3




> the correct routing cache entries would look something like this: 
> (this one works):
> assurancetourix:~> route -nC | head -2 ; route -nC | grep 234.20
> Kernel IP routing cache
> Source          Destination     Gateway         Flags Metric Ref    Use Iface
> 192.168.235.8   192.168.234.20  192.168.235.4         0      0        1 eth0
> 192.168.234.20  192.168.235.8   192.168.235.8   l     0      0        0 lo
> 192.168.235.8   192.168.234.20  192.168.235.4         0      0        0 eth0
> 
> The routing table is: 
> 
> Kernel IP routing table
> Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
> 0.0.0.0         192.168.235.251 0.0.0.0         UG    0      0        0 eth0
> 169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 eth0
> 192.168.234.0   192.168.235.4   255.255.255.0   UG    0      0        0 eth0
> 192.168.235.0   0.0.0.0         255.255.255.0   U     1      0        0 eth0
> 192.168.235.2   192.168.235.4   255.255.255.255 UGH   0      0        0 eth0
> 
> It's the third line that is supposed to steer packets for '234.34 to 
> the proper router that knows how to reach the 234.0 network. 
> 
> As a temporary workaround I've added the route to 192.168.235.2 which
> is that same host, but not in the nameserver, so it's annoying. 
> (the other host that I can't  reach due to this problem doesn't have
> a second IP address (yet)). 
> 
> Oh... routing to 192.168.234.34 works on the router 192.168.235.4: 
> PING 192.168.234.34 (192.168.234.34) 56(84) bytes of data.
> 64 bytes from 192.168.234.34: icmp_req=1 ttl=64 time=41.5 ms
> 
> Anyway, what would you suggest for me to try to get that invalid
> route cache entry dropped?
> 
> Drop the default route? Ok. Done: 
> # route del default
> # ping 192.168.234.34
> 2 packets transmitted, 0 received, 100% packet loss, time 1007ms
> 
> I'm used to the default route being at the bottom, but deleting it should
> be enough to prevent it from being found first, right? :-)
> 
> Add a host route to this host explicitly naming the router?
> 
> assurancetourix:~# route add 192.168.234.34 gw driepoot
> assurancetourix:~# route -n 
> Kernel IP routing table
> Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
> 169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 eth0
> 192.168.234.0   192.168.235.4   255.255.255.0   UG    0      0        0 eth0
> 192.168.234.34  192.168.235.4   255.255.255.255 UGH   0      0        0 eth0
> 192.168.235.0   0.0.0.0         255.255.255.0   U     1      0        0 eth0
> 192.168.235.2   192.168.235.4   255.255.255.255 UGH   0      0        0 eth0
> assurancetourix:~# ping 192.168.234.34 -c 2
> ....
> 2 packets transmitted, 0 received, 100% packet loss, time 1008ms
> 
> Still the packets end up on the ethernet with the 192.168.235.251 router's 
> Ethernet address..... 
> 
> assurancetourix:~# route -nC | head -2 ; route -nC | grep 234.34
> Kernel IP routing cache
> Source          Destination     Gateway         Flags Metric Ref    Use Iface
> 192.168.235.8   192.168.234.34  192.168.235.251       0      0        0 eth0
> 192.168.235.8   192.168.234.34  192.168.235.251       0      0        0 eth0
> 192.168.235.8   192.168.234.34  192.168.235.251       0      0        5 eth0
> 


Better use "ip -s route list cache" to diagnose problems (more
information)

> 
> # ifconfig eth0 down
> # route -n 
> <empty table> 
> # ifconfig eth0 up
> <old routing table is restored automatically??? apparently with the routing
> cache entries as well....> 
> 
> 
> I initially thought that this was a problem with the routing
> cache entry being too persistent in the kernel. While documenting
> this while writing this email, I've found that I can flush the whole routing
> cache with "ip route flush cache"  . 
> 
> However the routing cache entry springs back to life when I first
> ping the 234.34 host. Even when the problem machine doesn't have a
> default route, so it shouldn't know about the 235.251 default router. 
> 
> This is getting weirder and weirder. 
> 
> During all this I have
> # tcpdump -nei eth0 net 192.168.234.0/24
> running. If my machine were to get an ICMP redirect from somewhere
> I'd see it, right? 
> 
> It could be that the 192.168.235.251 router is proxy-arping (incorreclty)
> for the problem hosts. But then my workstation would have to be
> ARPing in the first place. 
> 
> # route add 192.168.234.200 eth0
> # ping 192.168.234.200
> gives: 
> 15:31:33.857343 00:23:54:15:1f:a9 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 192.168.234.200 tell 192.168.235.8, length 28
> in the TCPDUMP, so my machine is not arping for 192.168.234.34. 
> 
> Any suggestions? Any at all?
> 
> 	Roger. 
> 


