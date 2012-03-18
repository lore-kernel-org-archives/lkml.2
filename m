Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2CRSlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 14:41:09 -0400
Received: from mail1.windriver.com ([147.11.146.13]:47503 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab2CRSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 14:41:07 -0400
Date: Sun, 18 Mar 2012 14:41:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for March 18, 2012
Message-ID: <20120318184105.GC2095@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This represents the state of things as of Friday since I didn't
get a report out then.  Four new arches have been added but none
of them yet build (top four below).

New breakage since last report:
	AM33:asb2303_defconfig,asb2364_defconfig (toolchain?)
	frv:defconfig  (arch/frv/kernel/head.S operand out of range)
	h8300:defconfig (time.c: implicit declaration 'get_irq_regs')
	m32r:m32700ut.smp_defconfig (No rule to make vmlinux.bin)
	m68k:allmodconfig (persistent_ram.c: implicit declaration 'memblock_reserve')
	sparc[64]:allmodconfig (hda/patch_sigmatel.c: 'stac93xx_set_power_state' undeclared)
	sparc/m68k:allmodconfig (implicit completion.h - already fixed)

Randconfig fails that may or may not be new (by their very nature):
	i386: samsung-laptop.c: implicit declaration of 'isalnum'
		(http://kisskb.ellerman.id.au/kisskb/buildresult/5884289/)
	powerpc: kernel/fadump.c:407:2: error: 'crashing_cpu' undeclared
		(http://kisskb.ellerman.id.au/kisskb/buildresult/5884411/)
	x86_64: No rule to make scsi/aic7xxx/aicasm/*.[chyl]
		http://kisskb.ellerman.id.au/kisskb/buildresult/5884287/

Builds that are fixed since last report:
	ARM:orion5x_defconfig
	powerpc:allmodconfig


Note: The randconfig fails are only listed once and not tracked
in the below listing.

            ------------------------------------------------

Latest results at:
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of March 18th, 2012:
===============================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15, 18:04
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	incompatible toolchain?
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:u8500_defconfig
	when:	Mar 14, 08:53
	why:	mach-ux500/timer.c: 'IRQ_LOCALTIMER' undeclared
	status:	fixed
	fix:	http://marc.info/?l=linux-next&m=133193275811234&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884194/
	
ARM:mxs_defconfig
	when:	Mar 14, 00:19
	why:	Inconsistent kallsyms data This is a bug - please report
	status: UFO bug keeps appearing at random
	fix:	
	ref:	https://lkml.org/lkml/2011/8/2/233
	ref:	https://lkml.org/lkml/2011/10/8/70

ARM:eseries_pxa_defconfig
	when:	Mar 14, 05:15
	why:	tmio_mmc_pio.c:: 'struct tmio_mmc_host' has no member named 'native_hotplug'
	status:	bisected and reported (PaulG).
	fix:	Apparently an ordering issue that should now be resolved.
	ref:	http://permalink.gmane.org/gmane.linux.kernel.mmc/13491
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869552/

ARM:netx_defconfig,pnx4008_defconfig 
	when:	Mar 14, 02:43
	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/
	ref:	https://lkml.org/lkml/2012/3/13/670

ARM:cam60_defconfig
	when:	Feb 23, 16:47
	why:	trace_entries.h: 'perf_ftrace_event_register' undeclared
	status:	S. Rostedt has a patch somewhere.
	fix:	
	ref:	irc (#linux-rt)

ARM:collie_defconfig
	when:	Feb 14, 19:10
	why:	locomolcd.c: error: 'sa1100fb_lcd_power' undeclared
	status:	fixed (PaulG) - pending integration
	fix:	http://marc.info/?l=linux-next&m=133105157730749&w=2
	ref:

ARM:imx_v4_v5_defconfig
	when:	Mar 9
	why:	clkdev.c: undefined reference to `vb2_dma_contig_memops'
	status:	
	fix:	
	ref:	

ARM:iop32x_defconfig,iop33x_defconfig
	when:	Nov 23, 13:42
	why:	restart.c: implicit declaration of function 'soft_restart'
	status:	fixed (PaulG) - pending integration
	fix:	http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/081461.html
	fix:	https://lkml.org/lkml/2012/3/14/253
	ref:

ARM:ixp4xx_defconfig
	when:	Oct 26, 01:40
	why:	gpio.h: implicit declaration of function '__gpio_get_value'
	status:	fixed (Imre Kaloz) - but possibly needs rework?
	fix:	https://lkml.org/lkml/2012/2/8/288
	ref:	https://lkml.org/lkml/2012/2/8/287

ARM:magician_defconfig
	when:	Feb 13, 19:10
	why:	magician.c: unknown field 'dev' specified in initializer
	status:	fixed (PaulG) - pending integration
	fix:
	ref:	http://marc.info/?l=linux-next&m=133106325903524&w=2

ARM:em_x270_defconfig
	when:	Feb 14, 01:15
	why:	em-x270.c: unknown field 'dev' specified in initializer
	status:	 fixed (PaulG) - pending integration
	fix:	http://www.spinics.net/lists/arm-kernel/msg164012.html
	ref:	http://www.spinics.net/lists/arm-kernel/msg163135.html

ARM:raumfeld_defconfig
	when:	Nov 23, 09:36
	why:	eeti_ts.c: implicit declaration of function 'irq_to_gpio'
	status:	perhaps broken since 2010?  See ref below.
	fix:	
	ref:	http://www.gossamer-threads.com/lists/linux/kernel/1291618?do=post_view_threaded#1291618

ARM:omap2plus_defconfig
	when:	Feb 16, 00:23
	why:	control.c:238: error: 'OMAP343X_CTRL_BASE' undeclared
	status:	PaulG did hack-n-slash, but at best a WIP, needs additonal reverts
	fix:	http://www.spinics.net/lists/arm-kernel/msg163120.html
	ref:	http://www.spinics.net/lists/arm-kernel/msg163262.html

ARM:at91x40_defconfig
	when:	Feb 28, 07:38 	
	why:	super.c:(.text+0x3ffd8): undefined reference to `vm_is_stack'
	status:	WIP, fix from PaulG + follow on from 
	fix:	http://marc.info/?l=linux-next&m=133096554131691&w=2
	ref:	http://marc.info/?l=linux-next&m=133104723928617&w=2

ARM:s3c2410_defconfig 
	when:	Mar 7, 22:59
	why:	s3c244x.c: expected declaration or statement at end of input
	status:	bad commit introduces truncated file; pending integration.
	fix:
	ref:	http://marc.info/?l=linux-next&m=133123680904853&w=2

ARM:arm-allnoconfig
	when:	forever
	why:	not supported
	status:	nothing pending, but patches accepted
	fix:	n/a
	ref:	https://lkml.org/lkml/2009/4/30/105
	ref:	http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/081218.html
----------------

AVR32:allnoconfig
	when:	May 26 2010, 20:49
	why:	at32_map_usart: undefined reference to `atmel_default_console_device'
	status:
	fix:
	ref:
---------------

bfin:***all-builds***
	when:	Jan 20, 22:13
	why:	undefined reference to `vm_is_stack'
	status:	WIP, fix from PaulG + follow on from Siddhesh Poyarekar
	fix:	http://marc.info/?l=linux-next&m=133096554131691&w=2
	ref:	http://marc.info/?l=linux-next&m=133104723928617&w=2
---------------

cris:***all-builds***
	when:	Mar 25, 22:05
	why:	include/linux/types.h:25: error expected ... before 'ino_t'
	status:	
	fix:	
	ref:	
----------------

crisv32:***all-builds***
	when:	Mar 25, 22:05
	why:	include/linux/types.h:25: error expected ... before 'ino_t'
	status:	
	fix:	
	ref:	
----------------

frv:defconfig
	when:	Mar 15
	why:	arch/frv/kernel/head.S operand out of range
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884666/
----------------

h8300:defconfig
	when:	Mar 15
	why:	time.c: implicit declaration of function 'get_irq_regs'
	status:	
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884668/
----------------

i386:allmodconfig
	when:	Mar 8, 20:41
	why:	ERROR: "pcibios_enabled" [drivers/video/uvesafb.ko] undefined!
	why:	ERROR: "mdfld_set_brightness" [drivers/gpu/drm/gma500/gma500_gfx.ko] undefined!
	status:	
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878506/
----------------

m32r:m32700ut.smp_defconfig
	when:	Mar 15
	why:	No rule to make target `arch/m32r/boot/compressed/vmlinux.bin
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884670/
----------------

m68k:allmodconfig
	when:	Mar 16
	why:	persistent_ram.c: implicit declaration of 'memblock_reserve'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884324/
	ref:	http://www.spinics.net/lists/linux-next/msg19343.html
----------------

mips:allmodconfig
	when:
	why:	driver_pci_host.c: implicit declaration of function 'pcibios_enable_device'
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5807000/
----------------

parisc:allmodconfig
	when:
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228

parisc64:a500_defconfig 
	when:
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

powerpc:allyesconfig
	when:	May 18 2009, 22:11
	why:	fat ass kernel with everything simply won't link
	status:	need to fix build config to ignore the final link
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5806793/

powerpc:mpc885_ads_defconfig
	when:	Mar 8, 19:45
	why:	fs/nfs/inode.c:1063: undefined reference to `crc32_le'
	status:	solved, NFS relies on CRC32 kconfig (PaulG)
	fix:	
	ref:	http://marc.info/?l=linux-nfs&r=1&b=201203&w=2
	ref:	
------------------

sh4:***all-builds***
	when:	Feb 24, 17:38
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

sparc[64]:allmodconfig
	when:	Mar 16, 09:21
	why:	patch_sigmatel.c: error: 'stac92xx_set_power_state' undeclared
	status:	reported
	fix:	
	ref:	http://marc.info/?l=linux-next&m=133209522419563&w=2
------------------

sparc/m68k:allmodconfig
	when:	Mar 14, 09:21
	why:	linux/mmc/core.h: field 'completion' has incomplete type
	status:	fixed Mar16th.
	fix:	http://marc.info/?l=linux-next&m=133190925501052&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869834/
------------------

um:um-defconfig
	when:	Sep 16 2010, 01:28
	why:	os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared
	status:	clearly broken forever, so does anyone care?
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/target/2979/

