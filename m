Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2DDCKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 22:10:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:49975 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2DDCKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 22:10:43 -0400
Date: Tue, 3 Apr 2012 22:10:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for April 3, 2012
Message-ID: <20120404021041.GA22988@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This represents the state of the builds as of Tues. EST.  Remember
that this report lags linux-next by ~24h so that builds can run.

Note that we are now also looking at some queued 3.5 content.

For system.h split, it seems today should be the last day it gets
additional mention as I think it is nearly all sorted now.

 Fixes for parisc, bfin, or32 and mips are now upstream.  I've only
 got commits for alpha, avr32, and ia64 remaining.  parisc[64]-modconfig
 still needs a looking at, though.

 SH4:	We had about 50% pass on builds yesterday.  A win vs. the
	100% fail we've had for a long time.  It is (briefly?) back
	to 100% fail as I've dropped my sh4 patch and Stephen is getting
	the tree info from PaulM who has a more complete fix series.

 ==============================================
	
New breakage since last report:
	ARM:iop33x_defconfig (ignore it; kallsyms extra pass. Almost a virus!)
	ARM:tct_hammer_defconfig,s3c2410_defconfig (missing "common.h")

Randconfig fails that may or may not be new (by their very nature):
	i386: "make randconfig" went bezerk and stabbed itself in the eye.
		http://kisskb.ellerman.id.au/kisskb/buildresult/6032573/
        powerpc: mpc512x_shared.c: parameter 1 ('port') has incomplete type
		http://kisskb.ellerman.id.au/kisskb/buildresult/6032653/

Builds that are fixed since last report:
	alpha:defconfig
	
Note: The randconfig fails are only listed once and not tracked
in the below listing.

I'm also not tracking the kallsyms extra pass stuff on ARM on
a per board basis anymore.  It has nothing to do with the board.
Why? See:  http://marc.info/?l=linux-next&m=133267456809502

            ------------------------------------------------

Latest results at:
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of April 3rd, 2012:
===============================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:tct_hammer_defconfig,s3c2410_defconfig
	when:	Apr 1
	why:	missing "common.h"
	status:	fix pending, borkage probably masked by other global borkage.
	fix:
	ref:	http://marc.info/?l=linux-next&m=133349249421262&w=2

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
	ref:	http://lists.infradead.org/pipermail/linux-arm-kernel/2012-April/092444.html

ARM:ixp4xx_defconfig
	when:	Oct 26
	why:	gpio.h: implicit declaration of function '__gpio_get_value'
	status:	fixed (Imre Kaloz) - but possibly needs rework?
	fix:	https://lkml.org/lkml/2012/2/8/288
	ref:	https://lkml.org/lkml/2012/2/8/287

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

AVR32:allnoconfig
	when:	May 26 2010, 20:49
	why:	at32_map_usart: undefined reference to `atmel_default_console_device'
	status:
	fix:
	ref:
---------------

bfin: 50% of builds
	when:	Mar 31
	why:	"Error: pcrel too far BFD_RELOC_BFIN_10" from kernel/time/timekeeping.c
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
	why:	undefined reference to `pci_cardbus_resource_alignment'
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6030067/
----------------

ia64:defconfig
	when:	Apr 2
	why:	processor_idle.c: implicit declaration of function 'halt'
	status:	bisected (PaulG) - fix pending from Len
	fix:	
	ref:	http://marc.info/?l=linux-ia64&m=133346998813009&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6029643/
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
Cc: 
Bcc: 
Subject: sdf
Reply-To: 

Cc: 
Bcc: 
Subject: a
Reply-To: 

