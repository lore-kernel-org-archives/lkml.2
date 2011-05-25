Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab1EYXnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:43:02 -0400
Received: from lucidpixels.com ([75.144.35.66]:53340 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab1EYXnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:43:00 -0400
Date: Wed, 25 May 2011 19:42:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: e1000-devel@lists.sourceforge.net, linux-net@vger.kernel.org
Subject: Re: 2.6.39: kernel igb and e1000e-1.3.17 driver broken?
In-Reply-To: <alpine.DEB.2.02.1105251926070.9120@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1105251941550.9120@p34.internal.lan>
References: <alpine.DEB.2.02.1105251926070.9120@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 May 2011, Justin Piszcz wrote:

> Hello,
>
> I recently bought a 4-port Intel NIC (82580)
>
> 03:00.0 Ethernet controller: Intel Corporation 82580 Gigabit Network 
> Connection (rev 01)
> 03:00.1 Ethernet controller: Intel Corporation 82580 Gigabit Network 
> Connection (rev 01)
> 03:00.2 Ethernet controller: Intel Corporation 82580 Gigabit Network 
> Connection (rev 01)
> 03:00.3 Ethernet controller: Intel Corporation 82580 Gigabit Network 
> Connection (rev 01)
>
> Model name: Intel I340 Server Adapter
>
> Which uses this driver:
> | |    <M>   Intel(R) 82575/82576 PCI-Express Gigabit Ethernet support  | |
> | |    [ ]     Direct Cache Access (DCA) Support                        | |
>
> I have tried with and without the DCA support.
>
> Out of the four ports in the back, only two work, why is this?
>
> [ CARD ]
> 1 2 3 4
>  X X
>
> Where X = working.
>
> I've tried the built-in kernel driver from 2.6.39 as well as the latest
> e1000e driver from sf.net (1.3.17), any thoughts?
>
> eth0: negotiated 1000baseT-FD flow-control, link ok <- onboard
> eth1: negotiated 100baseTx-FD, link ok              <- middle port 1
> eth2: negotiated 1000baseT-FD flow-control, link ok <- middle port 2
> eth3: no link                                       <- left most port 
> (plugged in)
> eth4: no link                                       <- right most port 
> (plugged in)
>
> The last two parts of each mac addr:
>
> eth1      Link encap:Ethernet  HWaddr XX:XX:XX:XX:3b:f9  WORKING
> eth2      Link encap:Ethernet  HWaddr XX:XX:XX:XX:3b:fa  WORKING
> eth3      Link encap:Ethernet  HWaddr XX:XX:XX:XX:3b:f8  no link
> eth4      Link encap:Ethernet  HWaddr XX:XX:XX:XX:3b:fb  no link
>
> Thoughts?
>
> Justin.
>

Whoa,

Sent this out too early =)
My mistake, configuration error on user end :)
Problem was interfaces were not initialized properly (not UP).
Please disregard, sorry for the noise!

eth1: negotiated 100baseTx-FD, link ok
eth2: negotiated 1000baseT-FD flow-control, link ok
eth3: negotiated 1000baseT-FD flow-control, link ok
eth4: negotiated 1000baseT-FD flow-control, link ok

Justin.

