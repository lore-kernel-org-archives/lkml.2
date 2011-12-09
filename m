Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1LIOI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:08:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40892 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab1LIOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:08:26 -0500
MIME-Version: 1.0
In-Reply-To: <20111110130631.482fac9a@lxorguk.ukuu.org.uk>
References: <20111110124742.GA3246@vip.manty.net>
	<20111110130631.482fac9a@lxorguk.ukuu.org.uk>
Date: Fri, 9 Dec 2011 15:08:25 +0100
X-Google-Sender-Auth: Fj4TnpjVZKamxOdha5qHHjsrjEQ
Message-ID: <CAJk_L2EjSSq6-=rCH_JR1AiYsCRQjYAFMB_ZFNpL2=0vGeJUpQ@mail.gmail.com>
Subject: Re: problems with pata_via, hangs after random time
From: Santiago Garcia Mantinan <manty@manty.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I've been running the machine solidly for almost a month until today
it was turned off because of a power loss, the machine not to blame
this is my last recorded uptime:

28 days, 09:04:22 | Linux 3.1.0               Fri Nov 11 01:20:03 2011


> I think it would be useful to see if it runs solidly with the exact same
> configuration but the old IDE driver. The error dump you have is bizarre
> to say the least so it'd hard to guess what is going on.

This is the diff, config.vip.new is the "new" kernel, the one with the
new ata drivers and .config is the one I used for the last 28 days to
see if it could run stable, as you can see, the only thing I changed
was that I removed the new ata drivers to get back to the old ide
ones.

--- ../config.vip.new	2011-10-25 00:07:43.327519334 +0200
+++ .config	2011-11-11 00:49:32.070988433 +0100
@@ -677,7 +677,83 @@
 # CONFIG_SENSORS_LIS3LV02D is not set
 # CONFIG_MISC_DEVICES is not set
 CONFIG_HAVE_IDE=y
-# CONFIG_IDE is not set
+CONFIG_IDE=y
+
+#
+# Please see Documentation/ide/ide.txt for help/info on IDE drives
+#
+CONFIG_IDE_XFER_MODE=y
+CONFIG_IDE_TIMINGS=y
+CONFIG_IDE_ATAPI=y
+# CONFIG_BLK_DEV_IDE_SATA is not set
+CONFIG_IDE_GD=y
+CONFIG_IDE_GD_ATA=y
+# CONFIG_IDE_GD_ATAPI is not set
+CONFIG_BLK_DEV_IDECD=y
+CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
+# CONFIG_BLK_DEV_IDETAPE is not set
+# CONFIG_BLK_DEV_IDEACPI is not set
+# CONFIG_IDE_TASK_IOCTL is not set
+# CONFIG_IDE_PROC_FS is not set
+
+#
+# IDE chipset support/bugfixes
+#
+# CONFIG_IDE_GENERIC is not set
+# CONFIG_BLK_DEV_PLATFORM is not set
+# CONFIG_BLK_DEV_CMD640 is not set
+# CONFIG_BLK_DEV_IDEPNP is not set
+CONFIG_BLK_DEV_IDEDMA_SFF=y
+
+#
+# PCI IDE chipsets support
+#
+CONFIG_BLK_DEV_IDEPCI=y
+CONFIG_IDEPCI_PCIBUS_ORDER=y
+# CONFIG_BLK_DEV_GENERIC is not set
+# CONFIG_BLK_DEV_RZ1000 is not set
+CONFIG_BLK_DEV_IDEDMA_PCI=y
+# CONFIG_BLK_DEV_AEC62XX is not set
+# CONFIG_BLK_DEV_ALI15X3 is not set
+# CONFIG_BLK_DEV_AMD74XX is not set
+# CONFIG_BLK_DEV_ATIIXP is not set
+# CONFIG_BLK_DEV_CMD64X is not set
+# CONFIG_BLK_DEV_TRIFLEX is not set
+# CONFIG_BLK_DEV_CS5530 is not set
+# CONFIG_BLK_DEV_CS5535 is not set
+# CONFIG_BLK_DEV_CS5536 is not set
+# CONFIG_BLK_DEV_HPT366 is not set
+# CONFIG_BLK_DEV_JMICRON is not set
+# CONFIG_BLK_DEV_SC1200 is not set
+# CONFIG_BLK_DEV_PIIX is not set
+# CONFIG_BLK_DEV_IT8172 is not set
+# CONFIG_BLK_DEV_IT8213 is not set
+# CONFIG_BLK_DEV_IT821X is not set
+# CONFIG_BLK_DEV_NS87415 is not set
+# CONFIG_BLK_DEV_PDC202XX_OLD is not set
+# CONFIG_BLK_DEV_PDC202XX_NEW is not set
+# CONFIG_BLK_DEV_SVWKS is not set
+# CONFIG_BLK_DEV_SIIMAGE is not set
+# CONFIG_BLK_DEV_SIS5513 is not set
+# CONFIG_BLK_DEV_SLC90E66 is not set
+# CONFIG_BLK_DEV_TRM290 is not set
+CONFIG_BLK_DEV_VIA82CXXX=y
+# CONFIG_BLK_DEV_TC86C001 is not set
+
+#
+# Other IDE chipsets support
+#
+
+#
+# Note: most of these also require special kernel boot parameters
+#
+# CONFIG_BLK_DEV_4DRIVES is not set
+# CONFIG_BLK_DEV_ALI14XX is not set
+# CONFIG_BLK_DEV_DTC2278 is not set
+# CONFIG_BLK_DEV_HT6560B is not set
+# CONFIG_BLK_DEV_QD65XX is not set
+# CONFIG_BLK_DEV_UMC8672 is not set
+CONFIG_BLK_DEV_IDEDMA=y

 #
 # SCSI device support
@@ -717,92 +793,7 @@
 # CONFIG_SCSI_LOWLEVEL is not set
 # CONFIG_SCSI_DH is not set
 # CONFIG_SCSI_OSD_INITIATOR is not set
-CONFIG_ATA=y
-# CONFIG_ATA_NONSTANDARD is not set
-# CONFIG_ATA_VERBOSE_ERROR is not set
-# CONFIG_ATA_ACPI is not set
-# CONFIG_SATA_PMP is not set
-
-#
-# Controllers with non-SFF native interface
-#
-# CONFIG_SATA_AHCI is not set
-# CONFIG_SATA_AHCI_PLATFORM is not set
-# CONFIG_SATA_INIC162X is not set
-# CONFIG_SATA_ACARD_AHCI is not set
-# CONFIG_SATA_SIL24 is not set
-CONFIG_ATA_SFF=y
-
-#
-# SFF controllers with custom DMA interface
-#
-# CONFIG_PDC_ADMA is not set
-# CONFIG_SATA_QSTOR is not set
-CONFIG_ATA_BMDMA=y
-
-#
-# SATA SFF controllers with BMDMA
-#
-# CONFIG_ATA_PIIX is not set
-# CONFIG_SATA_MV is not set
-# CONFIG_SATA_NV is not set
-# CONFIG_SATA_PROMISE is not set
-# CONFIG_SATA_SIL is not set
-# CONFIG_SATA_SIS is not set
-# CONFIG_SATA_SVW is not set
-# CONFIG_SATA_ULI is not set
-# CONFIG_SATA_VIA is not set
-# CONFIG_SATA_VITESSE is not set
-
-#
-# PATA SFF controllers with BMDMA
-#
-# CONFIG_PATA_ALI is not set
-# CONFIG_PATA_AMD is not set
-# CONFIG_PATA_ARTOP is not set
-# CONFIG_PATA_ATIIXP is not set
-# CONFIG_PATA_ATP867X is not set
-# CONFIG_PATA_CMD64X is not set
-# CONFIG_PATA_CS5520 is not set
-# CONFIG_PATA_CS5530 is not set
-# CONFIG_PATA_CS5536 is not set
-# CONFIG_PATA_EFAR is not set
-# CONFIG_PATA_HPT366 is not set
-# CONFIG_PATA_HPT37X is not set
-# CONFIG_PATA_HPT3X2N is not set
-# CONFIG_PATA_HPT3X3 is not set
-# CONFIG_PATA_IT821X is not set
-# CONFIG_PATA_JMICRON is not set
-# CONFIG_PATA_MARVELL is not set
-# CONFIG_PATA_NETCELL is not set
-# CONFIG_PATA_NINJA32 is not set
-# CONFIG_PATA_NS87415 is not set
-# CONFIG_PATA_OLDPIIX is not set
-# CONFIG_PATA_PDC2027X is not set
-# CONFIG_PATA_PDC_OLD is not set
-# CONFIG_PATA_RDC is not set
-# CONFIG_PATA_SC1200 is not set
-# CONFIG_PATA_SCH is not set
-# CONFIG_PATA_SERVERWORKS is not set
-# CONFIG_PATA_SIL680 is not set
-# CONFIG_PATA_SIS is not set
-# CONFIG_PATA_TRIFLEX is not set
-CONFIG_PATA_VIA=y
-# CONFIG_PATA_WINBOND is not set
-
-#
-# PIO-only SFF controllers
-#
-# CONFIG_PATA_ISAPNP is not set
-# CONFIG_PATA_MPIIX is not set
-# CONFIG_PATA_NS87410 is not set
-# CONFIG_PATA_QDI is not set
-# CONFIG_PATA_RZ1000 is not set
-
-#
-# Generic fallback / legacy drivers
-#
-# CONFIG_ATA_GENERIC is not set
+# CONFIG_ATA is not set
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=y
 CONFIG_MD_AUTODETECT=y

> If it is reliable with the other drive then we can start doing close
> comparisons of register settings and the like

Well, I'd say that it was stable, the only weird thing being that it
found out a couple of DMA problems during this time in one of the
disks but it handled them well:

Nov 15 06:54:40 vip kernel: hdc: lost interrupt
Nov 15 06:54:40 vip kernel: hdc: ide_dma_sff_timer_expiry: DMA status (0x21)
Nov 15 06:54:40 vip kernel: hdc: DMA timeout error
Nov 15 06:54:40 vip kernel: hdc: DMA disabled
Nov 15 06:54:40 vip kernel: ide1: reset: success
Nov 15 06:54:40 vip kernel: hdc: ide_dma_sff_timer_expiry: DMA status (0x21)
Nov 15 06:54:40 vip kernel: hdc: DMA timeout error
Nov 15 06:54:40 vip kernel: hdc: DMA disabled
Nov 15 06:54:40 vip kernel: ide1: reset: success
Nov 15 06:54:40 vip kernel: hdc: ide_dma_sff_timer_expiry: DMA status (0x21)
Nov 15 06:54:40 vip kernel: hdc: DMA timeout error
Nov 15 06:54:40 vip kernel: hdc: DMA disabled
Nov 15 06:54:40 vip kernel: ide1: reset: success
Nov 15 06:54:40 vip kernel: hdc: ide_dma_sff_timer_expiry: DMA status (0x21)
Nov 15 06:54:40 vip kernel: hdc: DMA timeout error
Nov 15 06:54:40 vip kernel: hdc: DMA disabled
Nov 15 06:54:40 vip kernel: ide1: reset: success



Nov 27 22:52:34 vip kernel: hdc: lost interrupt
Nov 27 22:52:35 vip kernel: ide1: reset: success
Nov 27 22:53:26 vip kernel: EXT4-fs warning (device md0):
empty_dir:1926: bad directory (dir #35228451) - no `.' or `..'

This last thing was the only problem I found out of all the time, md0
is a software raid0 across both ide disks on which I have among other
things my Debian mirror and things like that, I fscked it, found some
problems with some of the Debian mirror files, some ended up on
lost+found I removed then and mirrored again, that was all.

I don't know what else to add, it looks to me that the old driver did
at least behave better than the new one and that the new one stalls
hanging the machine on some errors where the old one would reset the
disk and continue to work. I can try to gatter the info you tell me to
try to diagnose this and get a better new driver if you want.

I'm still running 3.1.0 if you want me to go for the 3.2 rcs or some
other version just let me know.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
