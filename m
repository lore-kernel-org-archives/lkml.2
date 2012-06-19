Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2FSSTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:19:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:64846 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2FSSTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:19:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167654707"
Message-ID: <4FE0C2A8.50602@intel.com>
Date: Tue, 19 Jun 2012 11:19:20 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: IO_PAGE_FAULTS with igb or igbvf on AMD IOMMU system
References: <20120619102041.GI2624@amd.com>
In-Reply-To: <20120619102041.GI2624@amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 03:20 AM, Joerg Roedel wrote:
> Hi,
>
> I am trying to use an Intel 82576 NIC on an AMD IOMMU system with
> SR-IOV. When I load the igb module with max_vfs=1 to enable a virtual
> function I get IO_PAGE_FAULTS from the virtual functions. The relevant
> part of dmesg is:
>
> [   45.788134] igb: Intel(R) Gigabit Ethernet Network Driver - version 3.4.7-k
> [   45.795090] igb: Copyright (c) 2007-2012 Intel Corporation.
> [   45.801049] igb 0000:02:00.0: irq 80 for MSI/MSI-X
> [   45.801056] igb 0000:02:00.0: irq 81 for MSI/MSI-X
> [   45.801061] igb 0000:02:00.0: irq 82 for MSI/MSI-X
> [   45.801067] igb 0000:02:00.0: irq 83 for MSI/MSI-X
> [   45.901445] pci 0000:02:10.0: [8086:10ca] type 00 class 0x020000
> [   45.901585] AMD-Vi: New device 0000:02:10.0
> [   45.906486] igb 0000:02:00.0: 1 VFs allocated
> [   45.937918] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
> [   45.945751] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
> [   46.071749] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
> [   46.078605] igb 0000:02:00.0: eth5: (PCIe:2.5Gb/s:Width x4) 00:1b:21:49:2e:cc
> [   46.085804] igb 0000:02:00.0: eth5: PBA No: E43709-003
> [   46.090946] igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 1 tx queue(s)
> [   46.098870] igb 0000:02:00.1: irq 84 for MSI/MSI-X
> [   46.098876] igb 0000:02:00.1: irq 85 for MSI/MSI-X
> [   46.098881] igb 0000:02:00.1: irq 86 for MSI/MSI-X
> [   46.098886] igb 0000:02:00.1: irq 87 for MSI/MSI-X
> [   46.104262] AMD-Vi: Using protection domain 23 for device 0000:02:00.0
> [   46.172988] IPv6: ADDRCONF(NETDEV_UP): eth5: link is not ready
> [   46.202875] pci 0000:02:10.1: [8086:10ca] type 00 class 0x020000
> [   46.203013] AMD-Vi: New device 0000:02:10.1
> [   46.207935] igb 0000:02:00.1: 1 VFs allocated
> [   46.373149] igb 0000:02:00.1: Intel(R) Gigabit Ethernet Network Connection
> [   46.380019] igb 0000:02:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:1b:21:49:2e:cd
> [   46.387213] igb 0000:02:00.1: eth6: PBA No: E43709-003
> [   46.392347] igb 0000:02:00.1: Using MSI-X interrupts. 2 rx queue(s), 1 tx queue(s)
> [   46.400072] igbvf 0000:02:10.0: enabling device (0000 -> 0002)
> [   46.405977] igbvf 0000:02:10.0: irq 88 for MSI/MSI-X
> [   46.405983] igbvf 0000:02:10.0: irq 89 for MSI/MSI-X
> [   46.405988] igbvf 0000:02:10.0: irq 90 for MSI/MSI-X
> [   46.411492] AMD-Vi: Using protection domain 24 for device 0000:02:00.1
> [   46.480625] IPv6: ADDRCONF(NETDEV_UP): eth6: link is not ready
> [   46.486980] igbvf 0000:02:10.0: Intel(R) 82576 Virtual Function
> [   46.492895] igbvf 0000:02:10.0: Address: ce:5e:41:2f:36:ce
> [   46.498510] igbvf 0000:02:10.1: enabling device (0000 -> 0002)
> [   46.504394] igbvf 0000:02:10.1: irq 91 for MSI/MSI-X
> [   46.504400] igbvf 0000:02:10.1: irq 92 for MSI/MSI-X
> [   46.504405] igbvf 0000:02:10.1: irq 93 for MSI/MSI-X
> [   46.527012] igbvf 0000:02:10.1: Intel(R) 82576 Virtual Function
> [   46.532931] igbvf 0000:02:10.1: Address: 52:3e:8f:47:60:da
> [   46.573209] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:10.0 domain=0x0000 address=0x000000021e170000 flags=0x0050]
> [   46.575620] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   46.589607] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:10.0 domain=0x0000 address=0x000000021e170040 flags=0x0050]
> [   46.600186] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:10.0 domain=0x0000 address=0x000000021e170080 flags=0x0050]
> [   46.610763] AMD-Vi: Event logged [IO_PAGE_FAULT device=02:10.0 domain=0x0000 address=0x000000021e1700c0 flags=0x0050]
> [   46.669940] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
>
> The devices (physical and virtual) are not operational after this. I
> think this is a problem in the igb or igbvf driver. The addresses
> reported in the IO_PAGE_FAULTS are system-ram addresses are were not
> handed out by the AMD IOMMU driver (the driver only hands out DMA
> handles below 4GB). Also the reported domain is 0 which means that the
> driver for that device has not yet issued _any_ call to the DMA-API. But
> the device is doing an DMA write request (as seen in the flags). Any
> ideas? Also let me know if you need any additional information.
>
> Thanks,
>
> 	Joerg
>
Joerg,

Based on the faults it would look like accessing the descriptor rings is
probably triggering the errors.  We allocate the descriptor rings using
dma_alloc_coherent so the rings should be mapped correctly.

The PF and VF will end up being locked out since they are hung on an
uncompleted DMA transaction.  Normally we recommend that PCIe Advanced
Error Reporting be enabled if an IOMMU is enabled so the device can be
reset after triggering a page fault event.

The first thing that pops into my head for possible issues would be that
maybe the VF pci_dev structure or the device structure isn't being
correctly initialized when SR-IOV is enabled on the igb interface.  Do
you know if there are any AMD IOMMU specific values on those structures,
such as the domain, that are supposed to be initialized prior to calling
the DMA API calls?  If so, have you tried adding debug output to verify
if those values are initialized on a VF prior to bringing up a VF interface?

Also have you tried any other SR-IOV capable devices on this system? 
That would be a valuable data point because we could then exclude the
SR-IOV code as being a possible cause for the issues if other SR-IOV
devices are working without any issues.

Thanks,

Alex
