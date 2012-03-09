Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030817Ab2CIUdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:33:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:53763 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030464Ab2CIUdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:33:47 -0500
Date: Fri, 9 Mar 2012 15:33:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for March 9, 2012
Message-ID: <20120309203345.GC10835@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New breakage since last report:
	ARM:orion5x_defconfig (OF header missing)
	ARM:simpad_defconfig (inconsistent kallsyms)
	ARM:imx_v4_v5_defconfig	(unresolved link vb2_dma_contig_memops)
	davinci_all_defconfig,omap1_defconfig,mpc85xx_defconfig
		 (trivial missing header, already fixed)


Latest results at:
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of March 9th, 2012:
===============================
	
ARM:arm-allnoconfig
	when:	forever
	why:	not supported
	status:	nothing pending, but patches accepted
	fix:	n/a
	ref:	https://lkml.org/lkml/2009/4/30/105
	ref:	http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/081218.html

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

ARM:davinci_all_defconfig,omap1_defconfig
	when:	Mar 9, 20:59
	why:	regmap.c error: implicit declaration of function 'devres_alloc
	status: already fixed
	fix:
	ref:	http://marc.info/?l=linux-next&m=133130596327850&w=2

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

ARM:orion5x_defconfig
	when:	Mar 9, 22:38
	why:	mv_cesa.c:1144: error: implicit declaration of function 'of_match_ptr'
	status:	fixed (PaulG), waiting integration
	fix:	http://marc.info/?l=linux-next&m=133132317502799&w=2
	ref:	

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

ARM:simpad_defconfig
	when:	Mar 9, 23:01
	why:	"Inconsistent kallsyms data This is a bug - please report about it"
	status:	UFO?  Keeps popping up on ARM builds now and again.
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5826597/
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

i386:allmodconfig
	when:	Mar 8, 20:41
	why:	ERROR: "__udivdi3" [drivers/media/dvb/frontends/rtl2830.ko] undefined!
	status:	looks fixed, pending integration
	fix:
	ref:	http://www.spinics.net/lists/linux-media/msg45093.html
----------------

i386:randconfig
	when:	Mar 9, 00:27
	why:	gpio-sodaville.c:130: error: unknown field 'dt_translate' specified in initializer
	status:	GrantL working on a merge fixup
	fix:
	ref:	http://marc.info/?l=linux-next&m=133122564032275&w=2
----------------


m68k:allmodconfig
	when:	Mar 9, 00:38
	why:	ERROR: "__udivdi3" [drivers/media/dvb/frontends/rtl2830.ko] undefined!
	status:	looks fixed, pending integration
	fix:
	ref:	http://www.spinics.net/lists/linux-media/msg45093.html
----------------

mips:cavium-octeon_defconfig
	when:	forever
	why:	"Error: Bad value (octeon) for -march" -- WTF?  bad toolchain?
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5807171/

mips:allmodconfig
	when:
	why:	driver_pci_host.c: implicit declaration of function 'pcibios_enable_device'
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5807000/
----------------

parisc:***all-builds***
	when:	Mar 7, 00:04
	why:	lib/bitmap.c: implicit declaration of function 'current_thread_info'
	status:	fixed
	fix:	PaulG - needs to include thread_info in the module-3.4 branch
	ref:	http://marc.info/?l=linux-next&m=133108471012536&w=2
-----------------

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

powerpc:allmodconfig
	when:	Mar 8, 22:28
	why:	section .text overlaps section .kernel.dtb
	status:	need to fix build config to ignore the final link
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5818877/

powerpc:mpc885_ads_defconfig
	when:	Mar 8, 19:45
	why:	fs/nfs/inode.c:1063: undefined reference to `crc32_le'
	status:	odd - PaulG tried to reproduce it but failed.
	fix:
	ref:

powerpc:mpc85xx_defconfig
	when:	Mar 9, 20:59
	why:	regmap.c error: implicit declaration of function 'devres_alloc
	status: already fixed
	fix:
	ref:	http://marc.info/?l=linux-next&m=133130596327850&w=2
------------------

sh4:***all-builds***
	when:	Feb 24, 17:38
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

um:um-defconfig
	when:	Sep 16 2010, 01:28
	why:	os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared
	status:	clearly broken forever, so does anyone care?
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/target/2979/

