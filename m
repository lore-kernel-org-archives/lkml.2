Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2DAB3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 21:29:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:63776 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2DAB3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 21:29:47 -0400
Date: Sat, 31 Mar 2012 21:29:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dhowells@redhat.com>,
        <torvalds@linux-foundation.org>
Subject: linux-next: triage for March 31, 2012
Message-ID: <20120401012938.GA18804@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This represents the state of the builds as of Friday, since there
are no weekend linux-next builds.  This is still the 3.4 content.

Lots of breakage to report.  Most of it appears to be caused by
the asm/system.h split up going directly into Linus' tree without
any soak in linux-next.  Lets hope we can avoid this in the future.

I'm not going to list all the fails individually because there are
simply too many.  I'll try and do an arch overview and capture
what has been fixed already and what may remain as unfixed.

Note that "fixed" does not imply it made it into 3.4-rc1; I've
not yet checked what made it there.  But since we now have 3.4-rc1
I'm assuming that linux-next will move onto the 3.5 content, and
so we'll be largely changing context with these triage reports,
and this will represent the last 3.4 based status report.

Of course if breakage is due to mainline commits, please work
to get those in the pending 3.4-rcN (N>1) releases.  I think
the system.h fallout definitely falls into this category.

That said, the asm/system.h breakage that _should_ be fixed:

   ARM: ~10 fails. Olof has run all the defconfigs, and I think fixed them all
	http://lists.arm.linux.org.uk/lurker/message/20120330.143801.0025ae2c.en.html
	http://lists.arm.linux.org.uk/lurker/message/20120330.232025.982eba3a.en.html

   SPARC: SamR/DaveM have already got the fixes to Linus
	http://marc.info/?l=linux-sparc&m=133315678827041&w=2

   S390: Should be fixed by Heiko
	http://marc.info/?l=linux-s390&m=133311833911171&w=2

The asm/system.h breakage that is possibly not fixed:

   alpha: include/linux/llist.h: asm/cmpxchg.h: No such file or directory
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000253/

   or32: include/asm-generic/cmpxchg.h: error: expected ')' before 'u8'
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000411/

   parisc: include/linux/llist.h: fatal: asm/cmpxchg.h: No such file or directory
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000168/

   tilegx: include/linux/llist.h: fatal: asm/cmpxchg.h: No such file or directory
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000412/

   bfin: include/asm-generic/cmpxchg.h: error: redefinition of '__xchg'
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000322/

   sh4: drivers/char/tpm/tpm.h: implicit declaration of function 'outb'
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000156/

   sh4: arch/sh/kernel/cpu/shmobile/pm.c: implicit declaration of 'set_bl_bit'
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000181/

   sh4: arch/sh/mm/flush-sh4.c implicit declaration of 'register_align' 
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000183/

   MIPS: system.h breakup wasn't tested on master with bug.h change.
	http://kisskb.ellerman.id.au/kisskb/buildresult/6000165/

 ==============================================
	
New breakage since last report:
	See above system.h chaos.

Randconfig fails that may or may not be new (by their very nature):
	powerpc: mpc512x_shared.c: parameter 1 ('port') has incomplete type
		http://kisskb.ellerman.id.au/kisskb/buildresult/6000263/

Builds that are fixed since last report:
	sh4: several configs that were failing on the fls thing that
	originated with DavidH's 1st commit are now passing, but the
	majority of sh4 still fail with the new issues listed above.

	bfin: all builds with the "L1 data A overflow" issue are fixed,
	but conveniently they were also broken via __xchg issue above.

The following have fixes posted for quite some time now, but the fixes
haven't yet been integrated.  Please have a look at these, as it would
be nice to have them in tree for rc2 as build regression fixes.
	ARM:magician_defconfig
	ARM:collie_defconfig
	ARM:iop32x_defconfig,iop33x_defconfig
	ARM:em_x270_defconfig
	AVR32:defconfig


Note: The randconfig fails are only listed once and not tracked
in the below listing.

            ------------------------------------------------

Latest results at:
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of March 31st, 2012:
================================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:netx_defconfig,pnx4008_defconfig 
	when:	Mar 14
	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/
	ref:	https://lkml.org/lkml/2012/3/13/670

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
	fix:	http://marc.info/?l=linux-arm-kernel&m=133124258707457&w=2
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
	status:	reported/fixed (PaulG)
	fix:	http://marc.info/?l=linux-arm-kernel&m=133239363802517&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5917107/

AVR32:allnoconfig
	when:	May 26 2010, 20:49
	why:	at32_map_usart: undefined reference to `atmel_default_console_device'
	status:
	fix:
	ref:
---------------

bfin:***all-builds***
	when:	Mar 26
	why:	bfin-uclinux-ld: L1 data A overflow!
	status:	unknown, binutils issue?
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5981475/
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
	why:	ERROR: "mdfld_set_brightness" [drivers/gpu/drm/gma500/gma500_gfx.ko] undefined!
	status:	
	fix:
	ref:	https://lkml.org/lkml/2012/3/24/122
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878506/
----------------

m32r:m32700ut.smp_defconfig
	when:	Mar 15
	why:	No rule to make target `arch/m32r/boot/compressed/vmlinux.bin
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884670/
----------------

m68k:sun3_defconfig,m68k_defconfig
	when:	Mar 26
	why:	sun3_NCR5380.c: static decl of 'sun3scsi_proc_info' follows non-static
	status:	
	fix:	
	ref:	http://marc.info/?l=linux-next&m=133279244817422&w=2

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
	status: one of many fixes mips needs...
	fix:	http://marc.info/?l=linux-wireless&m=133272031621916&w=2
	ref:	http://patchwork.ozlabs.org/patch/148614/
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

um:um-defconfig
	when:	Sep 16 2010, 01:28
	why:	os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared
	status:	clearly broken forever, so does anyone care?
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/target/2979/
