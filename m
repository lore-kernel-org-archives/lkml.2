Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab2CUWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:16:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:53385 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990Ab2CUWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:16:24 -0400
Date: Wed, 21 Mar 2012 18:16:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for March 21, 2012
Message-ID: <20120321221622.GA30957@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New breakage since last report:
	ARM:tct_hammer_defconfig (pgtable-generic.c: call to '__build_bug_failed')

Randconfig fails that may or may not be new (by their very nature):
	powerpc: pseries/iommu.c: 'struct pci_dn' has no member named 'eeh_config_addr'
		(http://kisskb.ellerman.id.au/kisskb/buildresult/5930424/)
	x86_64: No rule to make scsi/aic7xxx/aicasm/*.[chyl]
                (http://kisskb.ellerman.id.au/kisskb/buildresult/5930300/)

Builds that are fixed since last report:
	ARM:s3c2410_defconfig 


Note: The randconfig fails are only listed once and not tracked
in the below listing.

            ------------------------------------------------

Latest results at:
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of March 21th, 2012:
===============================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:cm_x2xx_defconfig
	when:	Mar 19
	why:	it8152.c: redefinition of 'dma_set_coherent_mask'
	status:	bisected and reported (PaulG)
	fix:
	ref:	http://marc.info/?l=linux-next&m=133226851818586&w=2

ARM:mxs_defconfig
	when:	Mar 14
	why:	Inconsistent kallsyms data This is a bug - please report
	status: UFO bug keeps appearing at random
	fix:	
	ref:	https://lkml.org/lkml/2011/8/2/233
	ref:	https://lkml.org/lkml/2011/10/8/70

ARM:netx_defconfig,pnx4008_defconfig 
	when:	Mar 14
	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/
	ref:	https://lkml.org/lkml/2012/3/13/670

ARM:cam60_defconfig
	when:	Feb 23
	why:	trace_entries.h: 'perf_ftrace_event_register' undeclared
	status:	S. Rostedt has a patch somewhere.
	fix:	
	ref:	irc (#linux-rt)

ARM:collie_defconfig
	when:	Feb 14
	why:	locomolcd.c: error: 'sa1100fb_lcd_power' undeclared
	status:	fixed (PaulG) - pending integration
	fix:	http://marc.info/?l=linux-next&m=133105157730749&w=2
	ref:

ARM:iop32x_defconfig,iop33x_defconfig
	when:	Nov 23
	why:	restart.c: implicit declaration of function 'soft_restart'
	status:	fixed (PaulG) - pending integration
	fix:	http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/081461.html
	fix:	https://lkml.org/lkml/2012/3/14/253
	ref:

ARM:ixp4xx_defconfig
	when:	Oct 26
	why:	gpio.h: implicit declaration of function '__gpio_get_value'
	status:	fixed (Imre Kaloz) - but possibly needs rework?
	fix:	https://lkml.org/lkml/2012/2/8/288
	ref:	https://lkml.org/lkml/2012/2/8/287

ARM:magician_defconfig
	when:	Feb 13
	why:	magician.c: unknown field 'dev' specified in initializer
	status:	fixed (PaulG) - pending integration
	fix:
	ref:	http://marc.info/?l=linux-next&m=133106325903524&w=2

ARM:em_x270_defconfig
	when:	Feb 14
	why:	em-x270.c: unknown field 'dev' specified in initializer
	status:	 fixed (PaulG) - pending integration
	fix:	http://www.spinics.net/lists/arm-kernel/msg164012.html
	ref:	http://www.spinics.net/lists/arm-kernel/msg163135.html

ARM:raumfeld_defconfig
	when:	Nov 23
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

ARM:tct_hammer_defconfig
	when:	Mar 21
	why:	pgtable-generic.c: call to '__build_bug_failed' attribute error
	status:	bisected and reported (PaulG)
	fix:
	ref:	http://marc.info/?l=linux-next&m=133236772927262&w=2

ARM:arm-allnoconfig
	when:	forever
	why:	not supported
	status:	nothing pending, but patches accepted
	fix:	n/a
	ref:	https://lkml.org/lkml/2009/4/30/105
	ref:	http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/081218.html
----------------

AVR32:defconfig
	when:	Mar 18
	why:	board.h: atmel_nand.h: No such file or directory
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5917107/

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
	status:	WIP, fix from Siddhesh Poyarekar
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
	why:	also seems gcc suffers an ICE
	status:	ICE bug lodged with gcc folks (TonyB)
	fix:
	ref:	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52598
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
------------------

sh4:***all-builds***
	when:	Feb 24, 17:38
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

tilegx:defconfig
	when:	Mar 19
	why:	`xfs_qm_exit' defined in discarded section `.exit.text' of fs/built-in.o
	status:	
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5924094/
------------------

um:um-defconfig
	when:	Sep 16 2010, 01:28
	why:	os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared
	status:	clearly broken forever, so does anyone care?
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/target/2979/
