Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab1DRSsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:48:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:24835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab1DRSsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:48:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,234,1301900400"; 
   d="scan'208";a="911233678"
Date: Mon, 18 Apr 2011 11:48:08 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: CAI Qian <caiqian@redhat.com>
Cc: linux-usb@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: kdump regression related to usb3 hub update
Message-ID: <20110418184808.GA7194@xanatos>
References: <75962266.482150.1300351616499.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <1569207539.482477.1300353689147.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569207539.482477.1300353689147.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAI, the hubs-v3-rebase branch is no longer up-to-date.  You should just
use Greg's usb-linus branch instead.  (The patches went through a couple
revs after the hubs-v3-rebase branch was abandoned.)  I'll be cleaning
out my xHCI branches shortly.

Sarah Sharp

On Thu, Mar 17, 2011 at 05:21:29AM -0400, CAI Qian wrote:
> Hello Sarah and others,
> 
> There is a regression using the latest Sarah's xhci hubs-v3-rebase tree, kdump kernel reset itself (log at the end of email). The first kernel also setup using IOMMU (intel_iommu=on). Removed intel_iommu=on from the kdump kernel parameter alone did not solve the problem. This is only reproducible when the first kernel is using IOMMU.
> 
> My environment setup is:
> 
> PCI-E card -> USB3 Disk
>            -> USB3 Hub -> USB3 Disk
>                        -> USB2 Hub -> USB2 Disk
> 
> I have been identified one or a few of the following patches caused the problem but need more time to narrow it down.
> 
> 288ead45fa6637e959015d055304f521cbbc0575
> USB: remove bogus USB_PORT_FEAT_*_SPEED symbols
> 
> 0eadcc09203349b11ca477ec367079b23d32ab91
> usb: USB3.0 ch11 definitions
> 
> b1a72b70bbb82237b1041c78edee305503f6da31
> USB: Remove bitmap #define from hcd.h
> 
> 50e6c947c6340f7ba81deca99e8a37f458a00e49
> USB: Fix usb_add_hcd() checkpatch errors.
> 
> 0abde136582234dd720270ec3d5aeba69eae4d03
> xhci: Rework port suspend structures for limited ports.
> 
> 8c0d6f920004f065c2571f32b7c28e7f850e9810
> xhci: Rename variables and reduce register reads.
> 
> ba764f4b37e2bcce069f6c9d96b8374ee85257ed
> USB 3.0 Hub Changes
> 
> Loading usb-storage.ko module
> Initializing USB Mass Storage driver...
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> Waiting 8 seconds for driver initialization.
> usb 7-1: New USB device found, idVendor=046d, idProduct=08af
> usb 7-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 7-2: new low speed USB device number 3 using uhci_hcd
> usb 7-2: New USB device found, idVendor=0624, idProduct=0307
> usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 7-2: Product: Avocent DSRIQ-USB
> usb 7-2: Manufacturer: Avocent
> input: Avocent Avocent DSRIQ-USB as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.0/input/input1
> generic-usb 0003:0624:0307.0001: input,hidraw0: USB HID v1.10 Keyboard [Avocent Avocent DSRIQ-USB] on usb-0000:00:1d.2-2/input0
> input: Avocent Avocent DSRIQ-USB as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.1/input/input2
> generic-usb 0003:0624:0307.0002: input,hidraw1: USB HID v1.10 Mouse [Avocent Avocent DSRIQ-USB] on usb-0000:00:1d.2-2/input1
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.0] fault addr ffbfb000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> Loading mii.ko module
> Loading v4l2-compat-ioctl32.ko module
> Loading mmicrocode: CPU0 sig=0x206c2, pf=0x1, revision=0xc
> icrocode.ko module
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.0] fault addr ffbfa000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.0] fault addr ffbf9000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr ffbf8000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 402
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 502
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 602
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 702
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 2
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 102
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 202
> DMAR:[DMA Write] Request device [0b:00.1] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> DRHD: handling fault status reg 302
> DMAR:[DMA Write] Request device [0b:00.0] fault addr fffff000 
> DMAR:[fault reason 01] Present bit in root entry is clear
> <reset>
> Initializing cgroup subsys cpuset
> Linux version 2.6.38-rc5+ ....
> 
> Thanks.
> 
> CAI Qian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
