Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1LVRlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:41:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59727 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1LVRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:41:38 -0500
Message-ID: <1324575692.2586.6.camel@edumazet-laptop>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Boot <bootc@bootc.net>
Cc: David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Date: Thu, 22 Dec 2011 18:41:32 +0100
In-Reply-To: <4EF352A2.2090604@bootc.net>
References: <4EF200BB.7000209@bootc.net>
	    <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	    <4EF2117F.6000803@bootc.net>
	    <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	    <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	    <4EF23BF2.4000601@bootc.net> <1324499332.2621.7.camel@edumazet-laptop>
	   <1324500775.2621.9.camel@edumazet-laptop> <4EF2568C.6040006@bootc.net>
	   <AEC29013-98F3-4A16-A88B-AD31C9E88EB8@bootc.net>
	  <1324528656.2621.19.camel@edumazet-laptop> <4EF300B2.3050903@bootc.net>
	 <1324563353.2153.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EF352A2.2090604@bootc.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 22 décembre 2011 à 15:54 +0000, Chris Boot a écrit :

> Eric,
> 
> I'm seeing a new problem now with IPv6 on my bridge, I don't know if 
> it's related to any of the patches you gave me.
> 
> Basically, I have eth0 and eth1 in a balance-rr bond (bond0), and this 
> is added as a port in a bridge. When the bond and bridge are freshly 
> brought up, IPv4 works fine but it appears to be deaf to IPv6 traffic. 
> It stays this way until I run 'tcpdump -i eth0' and 'tcpdump -i eth1'. 
> If I run tcpdump with the -p flag to not enable promiscuous mode, the 
> interfaces remain deaf. Only if they enter promiscuous mode do they 
> start to listen to each other. It also doesn't help to run tcpdump 
> against bond0 or br0 at all.
> 
> I'm not sure if once I've killed tcpdump they become deaf again, but I 
> have enough IPv6 traffic to keep the neighbour entry alive.

Thats probably a separate issue. It would be better to open a new thread
on netdev, instead of continuing this one.

IPv6 needs multicast capabilities, so maybe balance-rr bonding mode is
not propagating multicat filters properly on both nics.

It might be a problem on one of your NIC.

(tcpdump automatically installs promiscous mode, so all multicast frames
are received, regardless of previous multicast filters in place)




