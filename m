Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0FHAMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:12:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33968 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0FHAMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:12:44 -0400
Date: Mon, 7 Jun 2010 17:10:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] sound: move driver parameters to their own files
Message-Id: <20100607171038.6bc4fb08.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C0D8AED.0122:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move sound (OSS & ALSA) kernel parameters to their own files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jaroslav Kysela <perex@perex.cz>
Cc:	Takashi Iwai <tiwai@suse.de>
---
 Documentation/kernel-parameters.txt          |  167 -----------------
 Documentation/sound/alsa/alsa-parameters.txt |  135 +++++++++++++
 Documentation/sound/oss/oss-parameters.txt   |   51 +++++
 3 files changed, 192 insertions(+), 161 deletions(-)

--- /dev/null
+++ linux-2.6.35-rc2/Documentation/sound/oss/oss-parameters.txt
@@ -0,0 +1,51 @@
+                          OSS Kernel Parameters
+                          ~~~~~~~~~~~~~~~~~~~~~
+
+See Documentation/kernel-parameters.txt for general information on
+specifying module parameters.
+
+This document may not be entirely up to date and comprehensive. The command
+"modinfo -p ${modulename}" shows a current list of all parameters of a loadable
+module. Loadable modules, after being loaded into the running kernel, also
+reveal their parameters in /sys/module/${modulename}/parameters/. Some of these
+parameters may be changed at runtime by the command
+"echo -n ${value} > /sys/module/${modulename}/parameters/${parm}".
+
+
+	ad1848=		[HW,OSS]
+			Format: <io>,<irq>,<dma>,<dma2>,<type>
+
+	aedsp16=	[HW,OSS] Audio Excel DSP 16
+			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
+			See also header of sound/oss/aedsp16.c.
+
+	dmasound=	[HW,OSS] Sound subsystem buffers
+
+	mpu401=		[HW,OSS]
+			Format: <io>,<irq>
+
+	opl3=		[HW,OSS]
+			Format: <io>
+
+	pas2=		[HW,OSS] Format:
+			<io>,<irq>,<dma>,<dma16>,<sb_io>,<sb_irq>,<sb_dma>,<sb_dma16>
+
+	pss=		[HW,OSS] Personal Sound System (ECHO ESC614)
+			Format:
+			<io>,<mss_io>,<mss_irq>,<mss_dma>,<mpu_io>,<mpu_irq>
+
+	sscape=		[HW,OSS]
+			Format: <io>,<irq>,<dma>,<mpu_io>,<mpu_irq>
+
+	trix=		[HW,OSS] MediaTrix AudioTrix Pro
+			Format:
+			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
+
+	uart401=	[HW,OSS]
+			Format: <io>,<irq>
+
+	uart6850=	[HW,OSS]
+			Format: <io>,<irq>
+
+	waveartist=	[HW,OSS]
+			Format: <io>,<irq>,<dma>,<dma2>
--- /dev/null
+++ linux-2.6.35-rc2/Documentation/sound/alsa/alsa-parameters.txt
@@ -0,0 +1,135 @@
+                          ALSA Kernel Parameters
+                          ~~~~~~~~~~~~~~~~~~~~~~
+
+See Documentation/kernel-parameters.txt for general information on
+specifying module parameters.
+
+This document may not be entirely up to date and comprehensive. The command
+"modinfo -p ${modulename}" shows a current list of all parameters of a loadable
+module. Loadable modules, after being loaded into the running kernel, also
+reveal their parameters in /sys/module/${modulename}/parameters/. Some of these
+parameters may be changed at runtime by the command
+"echo -n ${value} > /sys/module/${modulename}/parameters/${parm}".
+
+
+	snd-ad1816a=	[HW,ALSA]
+
+	snd-ad1848=	[HW,ALSA]
+
+	snd-ali5451=	[HW,ALSA]
+
+	snd-als100=	[HW,ALSA]
+
+	snd-als4000=	[HW,ALSA]
+
+	snd-azt2320=	[HW,ALSA]
+
+	snd-cmi8330=	[HW,ALSA]
+
+	snd-cmipci=	[HW,ALSA]
+
+	snd-cs4231=	[HW,ALSA]
+
+	snd-cs4232=	[HW,ALSA]
+
+	snd-cs4236=	[HW,ALSA]
+
+	snd-cs4281=	[HW,ALSA]
+
+	snd-cs46xx=	[HW,ALSA]
+
+	snd-dt019x=	[HW,ALSA]
+
+	snd-dummy=	[HW,ALSA]
+
+	snd-emu10k1=	[HW,ALSA]
+
+	snd-ens1370=	[HW,ALSA]
+
+	snd-ens1371=	[HW,ALSA]
+
+	snd-es968=	[HW,ALSA]
+
+	snd-es1688=	[HW,ALSA]
+
+	snd-es18xx=	[HW,ALSA]
+
+	snd-es1938=	[HW,ALSA]
+
+	snd-es1968=	[HW,ALSA]
+
+	snd-fm801=	[HW,ALSA]
+
+	snd-gusclassic=	[HW,ALSA]
+
+	snd-gusextreme=	[HW,ALSA]
+
+	snd-gusmax=	[HW,ALSA]
+
+	snd-hdsp=	[HW,ALSA]
+
+	snd-ice1712=	[HW,ALSA]
+
+	snd-intel8x0=	[HW,ALSA]
+
+	snd-interwave=	[HW,ALSA]
+
+	snd-interwave-stb=
+			[HW,ALSA]
+
+	snd-korg1212=	[HW,ALSA]
+
+	snd-maestro3=	[HW,ALSA]
+
+	snd-mpu401=	[HW,ALSA]
+
+	snd-mtpav=	[HW,ALSA]
+
+	snd-nm256=	[HW,ALSA]
+
+	snd-opl3sa2=	[HW,ALSA]
+
+	snd-opti92x-ad1848=
+			[HW,ALSA]
+
+	snd-opti92x-cs4231=
+			[HW,ALSA]
+
+	snd-opti93x=	[HW,ALSA]
+
+	snd-pmac=	[HW,ALSA]
+
+	snd-rme32=	[HW,ALSA]
+
+	snd-rme96=	[HW,ALSA]
+
+	snd-rme9652=	[HW,ALSA]
+
+	snd-sb8=	[HW,ALSA]
+
+	snd-sb16=	[HW,ALSA]
+
+	snd-sbawe=	[HW,ALSA]
+
+	snd-serial=	[HW,ALSA]
+
+	snd-sgalaxy=	[HW,ALSA]
+
+	snd-sonicvibes=	[HW,ALSA]
+
+	snd-sun-amd7930=
+			[HW,ALSA]
+
+	snd-sun-cs4231=	[HW,ALSA]
+
+	snd-trident=	[HW,ALSA]
+
+	snd-usb-audio=	[HW,ALSA,USB]
+
+	snd-via82xx=	[HW,ALSA]
+
+	snd-virmidi=	[HW,ALSA]
+
+	snd-wavefront=	[HW,ALSA]
+
+	snd-ymfpci=	[HW,ALSA]
--- linux-2.6.35-rc2.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.35-rc2/Documentation/kernel-parameters.txt
@@ -280,19 +280,12 @@ and is between 256 and 4096 characters. 
 			no: ACPI OperationRegions are not marked as reserved,
 			no further checks are performed.
 
-	ad1848=		[HW,OSS]
-			Format: <io>,<irq>,<dma>,<dma2>,<type>
-
 	add_efi_memmap	[EFI; X86] Include EFI memory map in
 			kernel's map of available physical RAM.
 
 	advansys=	[HW,SCSI]
 			See header of drivers/scsi/advansys.c.
 
-	aedsp16=	[HW,OSS] Audio Excel DSP 16
-			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
-			See also header of sound/oss/aedsp16.c.
-
 	agp=		[AGP]
 			{ off | try_unsupported }
 			off: disable AGP support
@@ -311,6 +304,9 @@ and is between 256 and 4096 characters. 
 	aic79xx=	[HW,SCSI]
 			See Documentation/scsi/aic79xx.txt.
 
+	ALSA		[HW,ALSA]
+			See Documentation/sound/alsa/alsa-parameters.txt
+
 	alignment=	[KNL,ARM]
 			Allow the default userspace alignment fault handler
 			behaviour to be specified.  Bit 0 enables warnings,
@@ -655,8 +651,6 @@ and is between 256 and 4096 characters. 
 			Disable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs.
 
-	dmasound=	[HW,OSS] Sound subsystem buffers
-
 	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support,
 			this option disables the debugging code at boot.
 
@@ -1523,9 +1517,6 @@ and is between 256 and 4096 characters. 
 			that the amount of memory usable for all allocations
 			is not too small.
 
-	mpu401=		[HW,OSS]
-			Format: <io>,<irq>
-
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
 
@@ -1849,9 +1840,6 @@ and is between 256 and 4096 characters. 
 			For example, to override I2C bus2:
 			omap_mux=i2c2_scl.i2c2_scl=0x100,i2c2_sda.i2c2_sda=0x100
 
-	opl3=		[HW,OSS]
-			Format: <io>
-
 	oprofile.timer=	[HW]
 			Use timer interrupt instead of performance counters
 
@@ -1863,6 +1851,9 @@ and is between 256 and 4096 characters. 
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
 
+	OSS		[HW,OSS]
+			See Documentation/sound/oss/oss-parameters.txt
+
 	osst=		[HW,SCSI] SCSI Tape Driver
 			Format: <buffer_size>,<write_threshold>
 			See also Documentation/scsi/st.txt.
@@ -1899,9 +1890,6 @@ and is between 256 and 4096 characters. 
 			Currently this function knows 686a and 8231 chips.
 			Format: [spp|ps2|epp|ecp|ecpepp]
 
-	pas2=		[HW,OSS] Format:
-			<io>,<irq>,<dma>,<dma16>,<sb_io>,<sb_irq>,<sb_dma>,<sb_dma16>
-
 	pas16=		[HW,SCSI]
 			See header of drivers/scsi/pas16.c.
 
@@ -2169,10 +2157,6 @@ and is between 256 and 4096 characters. 
 			[HW,MOUSE] Controls Logitech smartscroll autorepeat.
 			0 = disabled, 1 = enabled (default).
 
-	pss=		[HW,OSS] Personal Sound System (ECHO ESC614)
-			Format:
-			<io>,<mss_io>,<mss_irq>,<mss_dma>,<mpu_io>,<mpu_irq>
-
 	pt.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
@@ -2381,128 +2365,6 @@ and is between 256 and 4096 characters. 
 				1: Fast pin select (default)
 				2: ATC IRMode
 
-	snd-ad1816a=	[HW,ALSA]
-
-	snd-ad1848=	[HW,ALSA]
-
-	snd-ali5451=	[HW,ALSA]
-
-	snd-als100=	[HW,ALSA]
-
-	snd-als4000=	[HW,ALSA]
-
-	snd-azt2320=	[HW,ALSA]
-
-	snd-cmi8330=	[HW,ALSA]
-
-	snd-cmipci=	[HW,ALSA]
-
-	snd-cs4231=	[HW,ALSA]
-
-	snd-cs4232=	[HW,ALSA]
-
-	snd-cs4236=	[HW,ALSA]
-
-	snd-cs4281=	[HW,ALSA]
-
-	snd-cs46xx=	[HW,ALSA]
-
-	snd-dt019x=	[HW,ALSA]
-
-	snd-dummy=	[HW,ALSA]
-
-	snd-emu10k1=	[HW,ALSA]
-
-	snd-ens1370=	[HW,ALSA]
-
-	snd-ens1371=	[HW,ALSA]
-
-	snd-es968=	[HW,ALSA]
-
-	snd-es1688=	[HW,ALSA]
-
-	snd-es18xx=	[HW,ALSA]
-
-	snd-es1938=	[HW,ALSA]
-
-	snd-es1968=	[HW,ALSA]
-
-	snd-fm801=	[HW,ALSA]
-
-	snd-gusclassic=	[HW,ALSA]
-
-	snd-gusextreme=	[HW,ALSA]
-
-	snd-gusmax=	[HW,ALSA]
-
-	snd-hdsp=	[HW,ALSA]
-
-	snd-ice1712=	[HW,ALSA]
-
-	snd-intel8x0=	[HW,ALSA]
-
-	snd-interwave=	[HW,ALSA]
-
-	snd-interwave-stb=
-			[HW,ALSA]
-
-	snd-korg1212=	[HW,ALSA]
-
-	snd-maestro3=	[HW,ALSA]
-
-	snd-mpu401=	[HW,ALSA]
-
-	snd-mtpav=	[HW,ALSA]
-
-	snd-nm256=	[HW,ALSA]
-
-	snd-opl3sa2=	[HW,ALSA]
-
-	snd-opti92x-ad1848=
-			[HW,ALSA]
-
-	snd-opti92x-cs4231=
-			[HW,ALSA]
-
-	snd-opti93x=	[HW,ALSA]
-
-	snd-pmac=	[HW,ALSA]
-
-	snd-rme32=	[HW,ALSA]
-
-	snd-rme96=	[HW,ALSA]
-
-	snd-rme9652=	[HW,ALSA]
-
-	snd-sb8=	[HW,ALSA]
-
-	snd-sb16=	[HW,ALSA]
-
-	snd-sbawe=	[HW,ALSA]
-
-	snd-serial=	[HW,ALSA]
-
-	snd-sgalaxy=	[HW,ALSA]
-
-	snd-sonicvibes=	[HW,ALSA]
-
-	snd-sun-amd7930=
-			[HW,ALSA]
-
-	snd-sun-cs4231=	[HW,ALSA]
-
-	snd-trident=	[HW,ALSA]
-
-	snd-usb-audio=	[HW,ALSA,USB]
-
-	snd-via82xx=	[HW,ALSA]
-
-	snd-virmidi=	[HW,ALSA]
-
-	snd-wavefront=	[HW,ALSA]
-
-	snd-ymfpci=	[HW,ALSA]
-
 	softlockup_panic=
 			[KNL] Should the soft-lockup detector generate panics.
 
@@ -2517,9 +2379,6 @@ and is between 256 and 4096 characters. 
 	spia_pedr=
 	spia_peddr=
 
-	sscape=		[HW,OSS]
-			Format: <io>,<irq>,<dma>,<mpu_io>,<mpu_irq>
-
 	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
 			See Documentation/scsi/st.txt.
 
@@ -2659,10 +2518,6 @@ and is between 256 and 4096 characters. 
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
 
-	trix=		[HW,OSS] MediaTrix AudioTrix Pro
-			Format:
-			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
-
 	tsc=		Disable clocksource-must-verify flag for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
@@ -2679,12 +2534,6 @@ and is between 256 and 4096 characters. 
 	u14-34f=	[HW,SCSI] UltraStor 14F/34F SCSI host adapter
 			See header of drivers/scsi/u14-34f.c.
 
-	uart401=	[HW,OSS]
-			Format: <io>,<irq>
-
-	uart6850=	[HW,OSS]
-			Format: <io>,<irq>
-
 	uhash_entries=	[KNL,NET]
 			Set number of hash buckets for UDP/UDP-Lite connections
 
@@ -2850,9 +2699,6 @@ and is between 256 and 4096 characters. 
 			overridden by individual drivers. 0 will hide
 			cursors, 1 will display them.
 
-	waveartist=	[HW,OSS]
-			Format: <io>,<irq>,<dma>,<dma2>
-
 	wd33c93=	[HW,SCSI]
 			See header of drivers/scsi/wd33c93.c.
 
@@ -2885,5 +2731,4 @@ ________________________________________
 
 TODO:
 
-	Add documentation for ALSA options.
 	Add more DRM drivers.
