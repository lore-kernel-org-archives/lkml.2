Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab2DSCBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:01:40 -0400
Received: from mail1.windriver.com ([147.11.146.13]:34212 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2DSCBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:01:38 -0400
Date: Wed, 18 Apr 2012 22:01:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for April 18, 2012
Message-ID: <20120419020136.GB3443@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A handful of "new" (most likely pre-existing?) ARM failures from the
50-odd ARM builds Stephen added.  (some are kallsyms fails & ignored).
They are all tagged with the date "Apr 19 (possibly earlier?)" below.
[ http://marc.info/?l=linux-next&m=133472511300783&w=2 ]

Lots of "undefined reference to `vga_default_device'" stuff hitting
several arch (arm/m68k,...)  [ https://lkml.org/lkml/2012/4/18/157 ]

The samples/seccomp/bpf-direct.c stuff still breaks most allyes/allmod
configs.  Hopefully the fix for that is in the next treegen?
[ http://marc.info/?l=linux-next&m=133479674429442&w=2 ]

The gfs2 has issues, being broken on sparc and m68k.  Now bisected.
[ http://marc.info/?l=linux-next&m=133479890929994&w=2 ]

MIPS got a build failure in iwlwifi/iwl-core.h
[ http://kisskb.ellerman.id.au/kisskb/buildresult/6131791/ ]

All the rcu rcu_read_lock_nesting fallout is fixed

I've pushed some cris, frv and xtensa fixes into my linux-next feed,
so we'll see how that goes in several hours...

---------------------

New breakage since last report:
	all:all	vga fallout -- too many to list below, so here are some examples.
		sh7785lcr_32bit_defconfig, tilegx_defconfig, x86_64-randconfig
		m68k-allmodconfig, mips-p27_defconfig, orion5x_defconfig ...
		
		http://kisskb.ellerman.id.au/kisskb/buildresult/6131974/
		http://kisskb.ellerman.id.au/kisskb/buildresult/6127336/
		http://kisskb.ellerman.id.au/kisskb/buildresult/6131666/
		http://kisskb.ellerman.id.au/kisskb/buildresult/6131694/
		http://kisskb.ellerman.id.au/kisskb/buildresult/6127233/
		http://kisskb.ellerman.id.au/kisskb/buildresult/6126942/

	arm:various -- may not be new; many ARM builds just added

	mips:ip27_defconfig iwl-core.h: static decl of 'iwl_alloc_traffic_mem'
		 follows non-static decl
			
Randconfig fails that may or may not be new (by their very nature):
	powerpc: mpc52xx_pci.c: format '%x' expects 'unsigned int', but
	 arg2 has type 'resource_size_t'
		http://kisskb.ellerman.id.au/kisskb/buildresult/6131745/
	powerpc: leds-renesas-tpu.c: undefined ref to `led_classdev_register'
		http://kisskb.ellerman.id.au/kisskb/buildresult/6127187/

Builds that are fixed since last report:
	all:all	"rcu_read_lock_nesting undefined"

----------------------

Note1: The randconfig fails are only listed once and not tracked
in the below listing.

Note2: Build fails that are perpetual and/or unlikely to ever
get fixed are not tracked here.

Note3: Issues that Stephen finds and reverts/avoids before kicking
off the all-arch/all-config builds are also not tracked here.

Note4: I'm also not tracking the kallsyms extra pass on ARM on
a per board basis anymore.  It has nothing to do with the board.
Why? See:  http://marc.info/?l=linux-next&m=133267456809502

----------------------

Latest results at:
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of April 18th, 2012:
===============================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:mackerel_defconfig,ag5evm_defconfig
	when:	Apr 19 (possibly earlier?)
	why:	pfc-sh7372.c: undefined reference to `mmc_detect_change'
	why:	pfc-sh73a0.c: undefined reference to `mmc_detect_change'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131930/
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131908/

ARM:bcmring_defconfig
	when:	Apr 19 (possibly earlier?)
	why:	core.c: macro "AMBA_APB_DEVICE" requires 6 args, but only 5 given
	status:	fixed, pending feed into linux next.
	fix:
	ref:	http://www.spinics.net/lists/arm-kernel/msg169724.html

ARM:ezx_defconfig
	when:	Apr 19 (possibly earlier?)
	why:	ezx-pcap.c: implicit declaration of function 'irq_to_gpio'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131924/

ARM:mini2440_defconfig
	when:	Apr 19 (possibly earlier?)
	why:	arm-unknown-linux-gnueabi-ld: no machine record defined
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131932/

ARM:spear6xx_defconfig
	when:	Apr 19 (possibly earlier?)
	why:	asm/timex.h: fatal error: mach/timex.h: No such file
	status:
	fix:
	ref:

ARM:netx_defconfig,pnx4008_defconfig 
	when:	Mar 14
	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/
	ref:	https://lkml.org/lkml/2012/3/13/670

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
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6087324/
---------------

cris:various_defconfigs
	when:	Apr 16
	why:	AS      arch/cris/arch-v10/lib/checksumcopy.o
	why:	In file included from <command-line>:4:0:
	why:	include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
	why:	[macro magic for config_enabled]
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6123623/
	ref:	commit 69349c2dc01c489eccaa4c472542c08e370c6d7e

cris:allyesconfig,allmodconfig
	when:	Apr 3
	why:	too many to list here
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035250/
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035249/
----------------

frv:defconfig
	when:	Mar 15
	why:	undefined reference to `pci_cardbus_resource_alignment'
	status:	PaulG submitted a fix
	fix:	http://marc.info/?l=linux-pci&m=133478439025369&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6030067/
	
----------------

i386:allmodconfig
	when:	Apr 17
	why:	samples/seccomp/bpf-direct.c:47:2: error: #error Unsupported platform
	status:	reported
	fix:
	ref:	http://marc.info/?l=linux-kernel&m=133471624530782&w=2
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

m32r:m32700ut.smp_defconfig
	when:	Mar 15
	why:	No rule to make target `arch/m32r/boot/compressed/vmlinux.bin
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884670/
----------------

mips:ip27_defconfig
	when:	Apr 18
	why: iwlwifi/iwl-core.h: static decl of 'iwl_alloc_traffic_mem' follows non-static
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131791/

mips:allmodconfig
	when:	Apr 17
	why:	sound/oss/soundcard.c: 'MAX_DMA_CHANNELS' undeclared
	status: one of many fixes mips needs...
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6091660/
----------------

parisc:allmodconfig
	when:	?
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228

parisc64:a500_defconfig 
	when:	?
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

sparc/m68k:all
	when:	Apr 18
	why:	fs/gfs2/lops.c:379:42: error: request for member 'virtual' in something not a structure or union
	status:	reported/bisected by PaulG
	fix:
	ref:	http://marc.info/?l=linux-next&m=133479890929994&w=2
------------------
