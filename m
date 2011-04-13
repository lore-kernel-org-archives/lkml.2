Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1DMPr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:47:27 -0400
Received: from lucidpixels.com ([75.144.35.66]:36422 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab1DMPrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:47:25 -0400
Date: Wed, 13 Apr 2011 11:47:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: 2.6.38: rt2800usb: high latency (1000ms)?
Message-ID: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recall using this driver in staging and it crashing my machine, now 
thats its no longer in staging, I thought I'd give it another try..  Using 
the following wireless usb adapter, I'm seeing very high latency when using
the device in Linux, (with Windows, there are no problems).  Using Debian 
Testing + wpa_supplicant, using the following USB adapter:

Bus 001 Device 004: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 
Wireless Adapter

$ ping wireless-host
PING wireless-host (192.168.1.2) 56(84) bytes of data.
64 bytes from wireless-host (192.168.1.2): icmp_req=1 ttl=64 time=1002 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=2 ttl=64 time=3.84 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=3 ttl=64 time=23.3 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=4 ttl=64 time=40.1 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=5 ttl=64 time=991 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=6 ttl=64 time=0.583 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=7 ttl=64 time=1033 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=8 ttl=64 time=33.2 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=9 ttl=64 time=991 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=10 ttl=64 time=2.66 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=11 ttl=64 time=1029 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=12 ttl=64 time=31.3 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=14 ttl=64 time=997 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=15 ttl=64 time=0.884 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=16 ttl=64 time=1049 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=17 ttl=64 time=49.6 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=18 ttl=64 time=989 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=19 ttl=64 time=1.62 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=20 ttl=64 time=1047 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=21 ttl=64 time=47.6 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=22 ttl=64 time=982 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=23 ttl=64 time=0.607 ms

--- wireless-host ping statistics ---
24 packets transmitted, 22 received, 8% packet loss, time 23009ms
rtt min/avg/max/mdev = 0.583/470.533/1049.181/494.399 ms, pipe 2

I am using the following ralink firmware:
ii  firmware-ralink                     0.29                        Binary firmware for Ralink wireless cards

$ dpkg -L firmware-ralink
/.
/lib
/lib/firmware
/lib/firmware/rt3090.bin
/lib/firmware/rt2860.bin
/lib/firmware/rt73.bin
/lib/firmware/rt3071.bin
/lib/firmware/rt2561.bin
/lib/firmware/rt3070.bin
/lib/firmware/rt2661.bin
/lib/firmware/rt2870.bin
/lib/firmware/rt2561s.bin
/usr
/usr/share
/usr/share/bug
/usr/share/bug/firmware-ralink
/usr/share/bug/firmware-ralink/presubj
/usr/share/doc
/usr/share/doc/firmware-ralink
/usr/share/doc/firmware-ralink/changelog.gz
/usr/share/doc/firmware-ralink/copyright

Is there a certain firmware or other driver I should be using for this
USB wireless device so I do not get spouts of 1 second latency?

Justin.
