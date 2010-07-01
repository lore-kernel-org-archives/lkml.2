Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0GABba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:31:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38786 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab0GABb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:31:28 -0400
Date: Thu, 1 Jul 2010 11:31:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: linux-next: manual merge of the sound tree with the kernel-doc tree
Message-Id: <20100701113123.41742b29.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
Documentation/kernel-parameters.txt between commit
9445e31bd04236f4f8681bd2bbde1f4b7decce60 ("docs-scsi-prms") from the
kernel-doc tree and commit bcfde3347cadfc8967e9481b5a9ceae16ef95e38
("sound: move driver parameters to their own files") from the sound tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/kernel-parameters.txt
index 3cf6b49,8d443e7..0000000
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@@ -283,19 -283,30 +283,15 @@@ and is between 256 and 4096 characters
  	add_efi_memmap	[EFI; X86] Include EFI memory map in
  			kernel's map of available physical RAM.
  
- 	aedsp16=	[HW,OSS] Audio Excel DSP 16
- 			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
- 			See also header of sound/oss/aedsp16.c.
- 
 -	advansys=	[HW,SCSI]
 -			See header of drivers/scsi/advansys.c.
 -
  	agp=		[AGP]
  			{ off | try_unsupported }
  			off: disable AGP support
  			try_unsupported: try to drive unsupported chipsets
  				(may crash computer or cause data corruption)
  
 -	aha152x=	[HW,SCSI]
 -			See Documentation/scsi/aha152x.txt.
 -
 -	aha1542=	[HW,SCSI]
 -			Format: <portbase>[,<buson>,<busoff>[,<dmaspeed>]]
 -
 -	aic7xxx=	[HW,SCSI]
 -			See Documentation/scsi/aic7xxx.txt.
 -
 -	aic79xx=	[HW,SCSI]
 -			See Documentation/scsi/aic79xx.txt.
 -
+ 	ALSA		[HW,ALSA]
+ 			See Documentation/sound/alsa/alsa-parameters.txt
+ 
  	alignment=	[KNL,ARM]
  			Allow the default userspace alignment fault handler
  			behaviour to be specified.  Bit 0 enables warnings,
@@@ -1793,6 -1851,13 +1781,9 @@@
  				perfmon on Intel CPUs instead of the
  				CPU specific event set.
  
+ 	OSS		[HW,OSS]
+ 			See Documentation/sound/oss/oss-parameters.txt
+ 
 -	osst=		[HW,SCSI] SCSI Tape Driver
 -			Format: <buffer_size>,<write_threshold>
 -			See also Documentation/scsi/st.txt.
 -
  	panic=		[KNL] Kernel behaviour on panic
  			Format: <timeout>
  
@@@ -1825,9 -1890,9 +1816,6 @@@
  			Currently this function knows 686a and 8231 chips.
  			Format: [spp|ps2|epp|ecp|ecpepp]
  
- 	pas2=		[HW,OSS] Format:
- 			<io>,<irq>,<dma>,<dma16>,<sb_io>,<sb_irq>,<sb_dma>,<sb_dma16>
- 
 -	pas16=		[HW,SCSI]
 -			See header of drivers/scsi/pas16.c.
 -
  	pause_on_oops=
  			Halt all CPUs after the first oops has been printed for
  			the specified number of seconds.  This is to be used if
@@@ -2417,9 -2379,9 +2279,6 @@@
  	spia_pedr=
  	spia_peddr=
  
- 	sscape=		[HW,OSS]
- 			Format: <io>,<irq>,<dma>,<mpu_io>,<mpu_irq>
- 
 -	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
 -			See Documentation/scsi/st.txt.
 -
  	stacktrace	[FTRACE]
  			Enabled the stack tracer on boot up.
  
@@@ -2563,12 -2531,9 +2418,6 @@@
  			<port#>,<js1>,<js2>,<js3>,<js4>,<js5>,<js6>,<js7>
  			See also Documentation/input/joystick-parport.txt
  
- 	uart401=	[HW,OSS]
- 			Format: <io>,<irq>
- 
- 	uart6850=	[HW,OSS]
- 			Format: <io>,<irq>
- 
 -	u14-34f=	[HW,SCSI] UltraStor 14F/34F SCSI host adapter
 -			See header of drivers/scsi/u14-34f.c.
 -
  	uhash_entries=	[KNL,NET]
  			Set number of hash buckets for UDP/UDP-Lite connections
  
@@@ -2734,9 -2699,12 +2583,6 @@@
  			overridden by individual drivers. 0 will hide
  			cursors, 1 will display them.
  
- 	waveartist=	[HW,OSS]
- 			Format: <io>,<irq>,<dma>,<dma2>
- 
 -	wd33c93=	[HW,SCSI]
 -			See header of drivers/scsi/wd33c93.c.
 -
 -	wd7000=		[HW,SCSI]
 -			See header of drivers/scsi/wd7000.c.
 -
  	watchdog timers	[HW,WDT] For information on watchdog timers,
  			see Documentation/watchdog/watchdog-parameters.txt
  			or other driver-specific files in the
