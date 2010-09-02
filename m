Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0IBSt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:49:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:46483 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0IBStZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:49:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,309,1280732400"; 
   d="scan'208";a="653697331"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Tony Jones <tonyj@suse.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bphilips@suse.de" <bphilips@suse.de>
Date: Thu, 2 Sep 2010 11:49:12 -0700
Subject: RE: high latency on 82573L
Thread-Topic: high latency on 82573L
Thread-Index: ActKUGe6JIl1jpD+TL63GGAM1w+bagAd8TxA
Message-ID: <8DD2590731AB5D4C9DBF71A877482A900168E59EFA@orsmsx509.amr.corp.intel.com>
References: <20100902033900.GA5283@suse.de>
In-Reply-To: <20100902033900.GA5283@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 01, 2010 8:39 PM, Tony Jones wrote:
> Hi.
> 
> Since commit 6f461f6c7c (e1000e: enable/disable ASPM L0s and L1 and
> ERT according to hardware errata) I'm seeing high latencies on my
> Thinkpad T60p. 
> 
> 02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit
> 	Ethernet Controller Subsystem: Lenovo ThinkPad T60
> 	Flags: bus master, fast devsel, latency 0, IRQ 30
> 	Memory at ee000000 (32-bit, non-prefetchable) [size=128K]
> 	I/O ports at 3000 [size=32]
> 	Capabilities: [c8] Power Management version 2
> 	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> 	Capabilities: [e0] Express Endpoint, MSI 00
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [140] Device Serial Number 00-1a-6b-ff-ff-6c-7e-a4
> 	Kernel driver in use: e1000e
> 
> # uname -r
> 2.6.36-rc3-0-default
> # ping -c 20 192.168.1.1
> PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
> 64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.06 ms
> 64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=1007 ms
> 64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=698 ms
> 64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=198 ms
> 64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=697 ms
> 64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=1007 ms
> 64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=690 ms
> 64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=1007 ms
> 64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=682 ms
> 64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=1008 ms
> 64 bytes from 192.168.1.1: icmp_seq=11 ttl=64 time=1.03 ms
> 64 bytes from 192.168.1.1: icmp_seq=12 ttl=64 time=1007 ms
> 64 bytes from 192.168.1.1: icmp_seq=13 ttl=64 time=0.874 ms
> 64 bytes from 192.168.1.1: icmp_seq=14 ttl=64 time=1009 ms
> 64 bytes from 192.168.1.1: icmp_seq=15 ttl=64 time=1.72 ms
> 64 bytes from 192.168.1.1: icmp_seq=16 ttl=64 time=1006 ms
> 64 bytes from 192.168.1.1: icmp_seq=17 ttl=64 time=650 ms
> 64 bytes from 192.168.1.1: icmp_seq=18 ttl=64 time=1008 ms
> 64 bytes from 192.168.1.1: icmp_seq=19 ttl=64 time=642 ms
> 64 bytes from 192.168.1.1: icmp_seq=20 ttl=64 time=1643 ms
> 
> --- 192.168.1.1 ping statistics ---
> 20 packets transmitted, 20 received, 0% packet loss, time 19063ms
> rtt min/avg/max/mdev = 0.874/698.661/1643.392/439.376 ms, pipe 2
> 
> This is 2.6.36-rc3 yet commit 19833b5dff (e1000e: disable ASPM L1 on
> 82573) isn't having any effect for me.
> 
> For our OpenSUSE 11.3 kernels (2.6.34 based), reverting just
> 6f461f6c7c 
> solves the issue. For .36-rc3 reverting 6f461f6c7c plus of course
> 19833b5dff does the trick.
> 
> I'm happy to perform any testing to help narrow this down. LMK.
> 
> Tony

Please provide more verbose lspci output and include the PCI config
space, i.e. 'lspci -s 2:0.0 -vvv -xxx' after the driver is loaded,
your kernel .config and the full version number of the OpenSUSE
kernel.  Are there any messages in the system log regarding disabling
ASPM L0s and/or L1 on that device?

I can understand the latency with the OpenSUSE 2.6.34-based kernels
assuming commit 19833b5dff is not present, but I do not understand
the latency with 2.6.36-rc3.

Thanks,
Bruce.
