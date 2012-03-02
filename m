Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2CBRK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:10:26 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57280 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755096Ab2CBRKY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:10:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.152.114.35 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <20120302170638.3d172369d04335d9b921a28c@canb.auug.org.au>
References: <20120302170638.3d172369d04335d9b921a28c@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 2 Mar 2012 10:10:02 -0700
Message-ID: <CAErSpo6xQa4Rnv+RkkXCRjQ2HDZdBhorRv2c6pmWyXqRzhM4Vw@mail.gmail.com>
Subject: Re: linux-next: boot failure for next-20120227 and later (pci tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 11:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Jesse,
>
> Staring with next-20120227, one of my boot tests is failing like this:

Hi Stephen,

Thanks a lot for the test report and the bisection.  I wish I had a
machine to test on so I wouldn't have to bother you about it.

Any chance you could point me at the complete before/after dmesg logs?
 There should be information about the PCI host bridge apertures and
offsets in the "after" log.  If that's not enough, we might need to
collect new before/after logs with something like this
(whitespace-mangled):

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -71,7 +71,7 @@ CFLAGS-$(CONFIG_PPC64)        := -mminimal-toc
-mtraceback=no -mcall-aixdesc
 CFLAGS-$(CONFIG_PPC32) := -ffixed-r2 -mmultiple
 KBUILD_CPPFLAGS        += -Iarch/$(ARCH)
 KBUILD_AFLAGS  += -Iarch/$(ARCH)
-KBUILD_CFLAGS  += -msoft-float -pipe -Iarch/$(ARCH) $(CFLAGS-y)
+KBUILD_CFLAGS  += -msoft-float -pipe -Iarch/$(ARCH) $(CFLAGS-y) -DDEBUG
 CPP            = $(CC) -E $(KBUILD_CFLAGS)

 CHECKFLAGS     += -m$(CONFIG_WORD_SIZE) -D__powerpc__
-D__powerpc$(CONFIG_WORD_SIZE)__


> Freeing unused kernel memory: 488k freed
> modprobe used greatest stack depth: 10624 bytes left
> dracut: dracut-004-32.el6
> udev: starting version 147
> udevd (1161): /proc/1161/oom_adj is deprecated, please use /proc/1161/oom_score_adj instead.
> setfont used greatest stack depth: 10528 bytes left
> dracut: Starting plymouth daemon
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2689
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 9 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2701
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 20 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2713
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 8 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2725
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 8 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2737
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 8 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2749
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 8 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2761
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 7 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2773
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 7 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2785
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 8 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2797
> initcall .wait_scan_init+0x0/0xc4 [scsi_wait_scan] returned 0 after 8 usecs
> calling  .wait_scan_init+0x0/0xc4 [scsi_wait_scan] @ 2809
>
> and eventually our test system decides the machine is dead.  This is a
> PowerPC 970 based blade system  (several other PowerPC based systems to
> not fail).  A "normal" boot only shows .wait_scan_init being called
> once.  (I have "initcall_debug=y debug" on the command line).
>
> I bisected this down to:
>
> commit 6c5705fec63d83eeb165fe61e34adc92ecc2ce75
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Thu Feb 23 20:19:03 2012 -0700
>
>    powerpc/PCI: get rid of device resource fixups
>
>    Tell the PCI core about host bridge address translation so it can take
>    care of bus-to-resource conversion for us.
>
>    CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>
> The only seemingly relevant differences in the boot logs (good to bad) are:
>
>  pci 0000:03:02.0: supports D1 D2
> +PCI: Cannot allocate resource region 0 of PCI bridge 1, will remap
> +PCI: Cannot allocate resource region 1 of PCI bridge 1, will remap
> +PCI: Cannot allocate resource region 0 of PCI bridge 6, will remap
> +PCI: Cannot allocate resource region 1 of PCI bridge 6, will remap
> +PCI: Cannot allocate resource region 0 of PCI bridge 3, will remap
> +PCI: Cannot allocate resource region 1 of PCI bridge 3, will remap
> +PCI: Cannot allocate resource region 0 of device 0000:01:01.0, will remap
> +PCI: Cannot allocate resource region 2 of device 0000:01:01.0, will remap
> +PCI: Cannot allocate resource region 6 of device 0000:01:01.0, will remap
> +PCI: Cannot allocate resource region 0 of device 0000:03:00.0, will remap
> +PCI: Cannot allocate resource region 0 of device 0000:03:00.1, will remap
> +PCI: Cannot allocate resource region 0 of device 0000:03:02.0, will remap
> +PCI: Cannot allocate resource region 1 of device 0000:03:02.0, will remap
> +PCI: Cannot allocate resource region 2 of device 0000:03:02.0, will remap
> +PCI: Cannot allocate resource region 6 of device 0000:03:02.0, will remap
> +PCI: Cannot allocate resource region 0 of device 0000:06:04.0, will remap
> +PCI: Cannot allocate resource region 2 of device 0000:06:04.0, will remap
> +PCI: Cannot allocate resource region 0 of device 0000:06:04.1, will remap
> +PCI: Cannot allocate resource region 2 of device 0000:06:04.1, will remap
>  PCI: Probing PCI hardware done
>        .
>        .
>        .
>  calling  .radeonfb_init+0x0/0x248 @ 1
> -radeonfb 0000:03:02.0: Invalid ROM contents
> -radeonfb (0000:03:02.0): Invalid ROM signature 7272 should be 0xaa55
> -radeonfb: No ATY,RefCLK property !
> -xtal calculation failed: 26550
> -radeonfb: Used default PLL infos
> -radeonfb: Reference=27.00 MHz (RefDiv=60) Memory=166.00 Mhz, System=166.00 MHz
> -radeonfb: PLL min 12000 max 35000
> -i2c i2c-1: unable to read EDID block.
> -i2c i2c-1: unable to read EDID block.
> -i2c i2c-1: unable to read EDID block.
> -i2c i2c-3: unable to read EDID block.
> -i2c i2c-3: unable to read EDID block.
> -i2c i2c-3: unable to read EDID block.
> -i2c i2c-2: unable to read EDID block.
> -i2c i2c-2: unable to read EDID block.
> -i2c i2c-2: unable to read EDID block.
> -i2c i2c-3: unable to read EDID block.
> -i2c i2c-3: unable to read EDID block.
> -i2c i2c-3: unable to read EDID block.
> -radeonfb: Monitor 1 type CRT found
> -radeonfb: Monitor 2 type no found
> -Console: switching to colour frame buffer device 80x30
> -radeonfb (0000:03:02.0): ATI Radeon 515e "Q^"
> +radeonfb 0000:03:02.0: device not available (can't reserve [mem 0x00000000-0x07ffffff])
> +radeonfb (0000:03:02.0): Cannot enable PCI device
> +radeonfb: probe of 0000:03:02.0 failed with error -22
>  initcall .radeonfb_init+0x0/0x248 returned 0 after x usecs
>        .
>        .
>        .
>  ipr: IBM Power RAID SCSI Device Driver version: 2.5.2 (April 27, 2011)
> -ipr 0000:01:01.0: Found IOA with IRQ: 26
> -ipr 0000:01:01.0: Starting IOA initialization sequence.
> -ipr 0000:01:01.0: Adapter firmware version: 06160039
> -ipr 0000:01:01.0: IOA initialized.
> -scsi0 : IBM 572E Storage Adapter
> -scsi 0:0:1:0: Direct-Access     IBM-ESXS MAY2036RC        T106 PQ: 0 ANSI: 5
> -scsi: unknown device type 31
> -scsi 0:255:255:255: No Device         IBM      572E001          0150 PQ: 0 ANSI: 0
> +ipr 0000:01:01.0: device not available (can't reserve [mem 0x00000000-0x0003ffff])
> +ipr 0000:01:01.0: Cannot enable adapter
> +ipr: probe of 0000:01:01.0 failed with error -22
>  initcall .ipr_init+0x0/0x68 returned 0 after x usecs
>        .
>        .
>        .
>  calling  .tg3_init+0x0/0x3c @ 1
>  tg3.c:v3.122 (December 7, 2011)
> -tg3 0000:06:04.0: enabling device (0140 -> 0142)
> -sd 0:0:1:0: [sda] 71096640 512-byte logical blocks: (36.4 GB/33.9 GiB)
> -sd 0:0:1:0: [sda] Write Protect is off
> -sd 0:0:1:0: [sda] Mode Sense: d7 00 00 08
> -sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> - sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
> -sd 0:0:1:0: [sda] Attached SCSI disk
> -initcall 1_.sd_probe_async+0x0/0x1d0 returned 0 after x usecs
> -tg3 0000:06:04.0: eth0: Tigon3 [partno(none) rev 8100] (PCIX:133MHz:64-bit) MAC address 00:14:5e:9c:21:e2
> -tg3 0000:06:04.0: eth0: attached PHY is 5780 (1000Base-SX Ethernet) (WireSpeed[0], EEE[0])
> -tg3 0000:06:04.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
> -tg3 0000:06:04.0: eth0: dma_rwctrl[76144000] dma_mask[40-bit]
> -tg3 0000:06:04.1: enabling device (0140 -> 0142)
> -tg3 0000:06:04.1: eth1: Tigon3 [partno(none) rev 8100] (PCIX:133MHz:64-bit) MAC address 00:14:5e:9c:21:e3
> -tg3 0000:06:04.1: eth1: attached PHY is 5780 (1000Base-SX Ethernet) (WireSpeed[0], EEE[0])
> -tg3 0000:06:04.1: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> -tg3 0000:06:04.1: eth1: dma_rwctrl[76144000] dma_mask[40-bit]
> +tg3 0000:06:04.0: device not available (can't reserve [mem 0x00000000-0x0000ffff])
> +tg3 0000:06:04.0: Cannot enable PCI device, aborting
> +tg3: probe of 0000:06:04.0 failed with error -22
> +tg3 0000:06:04.1: device not available (can't reserve [mem 0x00000000-0x0000ffff])
> +tg3 0000:06:04.1: Cannot enable PCI device, aborting
> +tg3: probe of 0000:06:04.1 failed with error -22
>  initcall .tg3_init+0x0/0x3c returned 0 after x usecs
>        .
>        .
>        .
>  calling  .ohci_hcd_mod_init+0x0/0xfc @ 1
>  ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> -ohci_hcd 0000:03:00.0: OHCI Host Controller
> -ohci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 1
> -ohci_hcd 0000:03:00.0: irq 19, io mem 0x100a1001000
> -hub 1-0:1.0: USB hub found
> -hub 1-0:1.0: 3 ports detected
> -ohci_hcd 0000:03:00.1: OHCI Host Controller
> -ohci_hcd 0000:03:00.1: new USB bus registered, assigned bus number 2
> -ohci_hcd 0000:03:00.1: irq 19, io mem 0x100a1000000
> -hub 2-0:1.0: USB hub found
> -hub 2-0:1.0: 3 ports detected
> +ohci_hcd 0000:03:00.0: device not available (can't reserve [mem 0x00000000-0x00000fff])
> +ohci_hcd 0000:03:00.1: device not available (can't reserve [mem 0x00000000-0x00000fff])
>  initcall .ohci_hcd_mod_init+0x0/0xfc returned 0 after x usecs
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
