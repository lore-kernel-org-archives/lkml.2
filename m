Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2FSKVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:21:01 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:8499
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207Ab2FSKU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:20:59 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zz4015Izz1202hzz15d4Rz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M5V0QK-01-3JI-02
X-M-MSG: 
Date: Tue, 19 Jun 2012 12:20:41 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
CC: <e1000-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: IO_PAGE_FAULTS with igb or igbvf on AMD IOMMU system
Message-ID: <20120619102041.GI2624@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to use an Intel 82576 NIC on an AMD IOMMU system with
SR-IOV. When I load the igb module with max_vfs=1 to enable a virtual
function I get IO_PAGE_FAULTS from the virtual functions. The relevant
part of dmesg is:

[   45.788134] igb: Intel(R) Gigabit Ethernet Network Driver - version 3.4.7-k
[   45.795090] igb: Copyright (c) 2007-2012 Intel Corporation.
[   45.801049] igb 0000:02:00.0: irq 80 for MSI/MSI-X
[   45.801056] igb 0000:02:00.0: irq 81 for MSI/MSI-X
[   45.801061] igb 0000:02:00.0: irq 82 for MSI/MSI-X
[   45.801067] igb 0000:02:00.0: irq 83 for MSI/MSI-X
[   45.901445] pci 0000:02:10.0: [8086:10ca] type 00 class 0x020000
[   45.901585] AMD-Vi: New device 0000:02:10.0
[   45.906486] igb 0000:02:00.0: 1 VFs allocated
[   45.937918] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
[   45.945751] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   46.071749] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
[   46.078605] igb 0000:02:00.0: eth5: (PCIe:2.5Gb/s:Width x4) 00:1b:21:49:2e:cc
[   46.085804] igb 0000:02:00.0: eth5: PBA No: E43709-003
[   46.090946] igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 1 tx queue(s)
[   46.098870] igb 0000:02:00.1: irq 84 for MSI/MSI-X
[   46.098876] igb 0000:02:00.1: irq 85 for MSI/MSI-X
[   46.098881] igb 0000:02:00.1: irq 86 for MSI/MSI-X
[   46.098886] igb 0000:02:00.1: irq 87 for MSI/MSI-X
[   46.104262] AMD-Vi: Using protection domain 23 for device 0000:02:00.0
[   46.172988] IPv6: ADDRCONF(NETDEV_UP): eth5: link is not ready
[   46.202875] pci 0000:02:10.1: [8086:10ca] type 00 class 0x020000
[   46.203013] AMD-Vi: New device 0000:02:10.1
[   46.207935] igb 0000:02:00.1: 1 VFs allocated
[   46.373149] igb 0000:02:00.1: Intel(R) Gigabit Ethernet Network Connection
[   46.380019] igb 0000:02:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:1b:21:49:2e:cd
[   46.387213] igb 0000:02:00.1: eth6: PBA No: E43709-003
[   46.392347] igb 0000:02:00.1: Using MSI-X interrupts. 2 rx queue(s), 1 tx queue(s)
[   46.400072] igbvf 0000:02:10.0: enabling device (0000 -> 0002)
[   46.405977] igbvf 0000:02:10.0: irq 88 for MSI/MSI-X
[   46.405983] igbvf 0000:02:10.0: irq 89 for MSI/MSI-X
[   46.405988] igbvf 0000:02:10.0: irq 90 for MSI/MSI-X
[   46.411492] AMD-Vi: Using protection domain 24 for device 0000:02:00.1
[   46.480625] IPv6: ADDRCONF(NETDEV_UP): eth6: link is not ready
[   46.486980] igbvf 0000:02:10.0: Intel(R) 82576 Virtual Function
[   46.492895] igbvf 0000:02:10.0: Address: ce:5e:41:2f:36:ce
[   46.498510] igbvf 0000:02:10.1: enabling device (0000 -> 0002)
[   46.504394] igbvf 0000:02:10.1: irq 91 for MSI/MSI-X
[   46.504400] igbvf 0000:02:10.1: irq 92 for MSI/MSI-X
[   46.504405] igbvf 0000:02:10.1: irq 93 for MSI/MSI-X
[   46.527012] igbvf 0000:02:10.1: Intel(R) 82576 Virtual Function
[   46.532931] igbvf 0000:02:10.1: Address: 52:3e:8f:47:60:da
[   46.573209] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:10.0 domain=0x0000 address=0x000000021e170000 flags=0x0050]
[   46.575620] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   46.589607] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:10.0 domain=0x0000 address=0x000000021e170040 flags=0x0050]
[   46.600186] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:10.0 domain=0x0000 address=0x000000021e170080 flags=0x0050]
[   46.610763] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:10.0 domain=0x0000 address=0x000000021e1700c0 flags=0x0050]
[   46.669940] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready

The devices (physical and virtual) are not operational after this. I
think this is a problem in the igb or igbvf driver. The addresses
reported in the IO_PAGE_FAULTS are system-ram addresses are were not
handed out by the AMD IOMMU driver (the driver only hands out DMA
handles below 4GB). Also the reported domain is 0 which means that the
driver for that device has not yet issued _any_ call to the DMA-API. But
the device is doing an DMA write request (as seen in the flags). Any
ideas? Also let me know if you need any additional information.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

