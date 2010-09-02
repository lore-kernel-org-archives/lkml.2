Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab0IBDjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:39:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:58830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0IBDjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:39:08 -0400
Date: Wed, 1 Sep 2010 20:39:00 -0700
From: Tony Jones <tonyj@suse.de>
To: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, alexander.h.duyck@intel.com,
        peter.p.waskiewicz.jr@intel.com, john.ronciak@intel.com
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        bphilips@suse.de
Subject: high latency on 82573L
Message-ID: <20100902033900.GA5283@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Since commit 6f461f6c7c (e1000e: enable/disable ASPM L0s and L1 and ERT 
according to hardware errata) I'm seeing high latencies on my Thinkpad T60p.

02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
	Subsystem: Lenovo ThinkPad T60
	Flags: bus master, fast devsel, latency 0, IRQ 30
	Memory at ee000000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at 3000 [size=32]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 00-1a-6b-ff-ff-6c-7e-a4
	Kernel driver in use: e1000e

# uname -r
2.6.36-rc3-0-default
# ping -c 20 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.06 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=1007 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=698 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=198 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=697 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=1007 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=690 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=1007 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=682 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=1008 ms
64 bytes from 192.168.1.1: icmp_seq=11 ttl=64 time=1.03 ms
64 bytes from 192.168.1.1: icmp_seq=12 ttl=64 time=1007 ms
64 bytes from 192.168.1.1: icmp_seq=13 ttl=64 time=0.874 ms
64 bytes from 192.168.1.1: icmp_seq=14 ttl=64 time=1009 ms
64 bytes from 192.168.1.1: icmp_seq=15 ttl=64 time=1.72 ms
64 bytes from 192.168.1.1: icmp_seq=16 ttl=64 time=1006 ms
64 bytes from 192.168.1.1: icmp_seq=17 ttl=64 time=650 ms
64 bytes from 192.168.1.1: icmp_seq=18 ttl=64 time=1008 ms
64 bytes from 192.168.1.1: icmp_seq=19 ttl=64 time=642 ms
64 bytes from 192.168.1.1: icmp_seq=20 ttl=64 time=1643 ms

--- 192.168.1.1 ping statistics ---
20 packets transmitted, 20 received, 0% packet loss, time 19063ms
rtt min/avg/max/mdev = 0.874/698.661/1643.392/439.376 ms, pipe 2

This is 2.6.36-rc3 yet commit 19833b5dff (e1000e: disable ASPM L1 on 82573)
isn't having any effect for me.

For our OpenSUSE 11.3 kernels (2.6.34 based), reverting just 6f461f6c7c
solves the issue. For .36-rc3 reverting 6f461f6c7c plus of course 19833b5dff 
does the trick.

I'm happy to perform any testing to help narrow this down. LMK.

Tony
