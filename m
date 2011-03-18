Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1CRGTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 02:19:52 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:41794 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1CRGTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 02:19:44 -0400
Date: Fri, 18 Mar 2011 02:19:38 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: linux-usb@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <1130369577.497880.1300429178678.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1569207539.482477.1300353689147.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Kdump failed with Intel IOMMU  (WAS Re: kdump regression related to
 usb3 hub update)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, this has nothing to do with usb3 hub update. I made a mistake that passed amd_iommu=on instead intel_iommu=on to the successful base kernel run. Hence, it passed once there and all testing for other kernels used the right parameters were failed.

The problem is still there though. Since this is the first time test this setup, not sure if this is regression or not.

CAI Qian

----- Original Message -----
> Hello Sarah and others,
> 
> There is a regression using the latest Sarah's xhci hubs-v3-rebase
> tree, kdump kernel reset itself (log at the end of email). The first
> kernel also setup using IOMMU (intel_iommu=on). Removed intel_iommu=on
> from the kdump kernel parameter alone did not solve the problem. This
> is only reproducible when the first kernel is using IOMMU.
> 
> My environment setup is:
> 
> PCI-E card -> USB3 Disk
> -> USB3 Hub -> USB3 Disk
> -> USB2 Hub -> USB2 Disk
> 
> I have been identified one or a few of the following patches caused
> the problem but need more time to narrow it down.
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
> input: Avocent Avocent DSRIQ-USB as
> /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.0/input/input1
> generic-usb 0003:0624:0307.0001: input,hidraw0: USB HID v1.10 Keyboard
> [Avocent Avocent DSRIQ-USB] on usb-0000:00:1d.2-2/input0
> input: Avocent Avocent DSRIQ-USB as
> /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.1/input/input2
> generic-usb 0003:0624:0307.0002: input,hidraw1: USB HID v1.10 Mouse
> [Avocent Avocent DSRIQ-USB] on usb-0000:00:1d.2-2/input1
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
