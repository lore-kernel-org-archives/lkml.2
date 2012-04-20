Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2DTCAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 22:00:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:34261 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2DTCAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 22:00:15 -0400
Date: Thu, 19 Apr 2012 22:00:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for April 19, 2012
Message-ID: <20120420020013.GA19964@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "undefined reference to `vga_default_device'" stuff appears to
still be unresolved, as it was in the Apr 19 fails still.     :-(
[ https://lkml.org/lkml/2012/4/18/157 ]

The samples/seccomp/bpf-direct.c stuff had a fix posted, but
not in time for Apr19 tree.  Hopefully it is gone tomorrow...
[ http://marc.info/?l=linux-next&m=133479674429442&w=2 ]

The parisc got borked by some kvm header shuffle it seems?
Now complaining about "file 'asm-generic/kvm_para.h' is not exported"
[ http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/ ]

The gfs2 stuff still has issues, but Apr 19th should be the
last day, as a fix was posted to follow up my bisect.
[ http://marc.info/?l=linux-next&m=133479890929994&w=2 ]

The frv defconfig got its 1st ever linux-next passing build!

The recent cris breakage was fixed with the "-traditional" removal.

The xtensa lost its BUG issue, but still has a final link issue.

---------------------

New breakage since last report:
	parisc:defconfig
			
Randconfig fails that may or may not be new (by their very nature):
	i386: drivers/isdn/hardware/avm/b1.o copy_from_user() buffer
	      size is not provably correct
		(http://kisskb.ellerman.id.au/kisskb/buildresult/6137763/)

Builds that are fixed since last report:
	frv:defconfig
	cris:several

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

Failures as of April 19th, 2012:
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
	ref:	http://article.gmane.org/gmane.linux.ports.sh.devel/14412
	ref:	http://article.gmane.org/gmane.linux.ports.sh.devel/14413
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

cris:allyesconfig,allmodconfig
	when:	Apr 3
	why:	too many to list here
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035250/
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035249/
----------------

i386:allmodconfig
	when:	Apr 17
	why:	samples/seccomp/bpf-direct.c:47:2: error: #error Unsupported platform
	status:	reported
	ref:	http://marc.info/?l=linux-kernel&m=133471624530782&w=2
----------------

h8300:defconfig
	when:	Mar 15
	why:	time.c: implicit declaration of function 'get_irq_regs'
	why:	also seems gcc suffers an ICE
	status:	ICE bug lodged with gcc folks (TonyB)
	ref:	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52598
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884668/
----------------

m32r:m32700ut.smp_defconfig
	when:	Mar 15
	why:	No rule to make target `arch/m32r/boot/compressed/vmlinux.bin
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884670/
----------------

mips:ip27_defconfig
	when:	Apr 18
	why: iwlwifi/iwl-core.h: static decl of 'iwl_alloc_traffic_mem' follows non-static
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131791/

mips:allmodconfig
	when:	Apr 17
	why:	sound/oss/soundcard.c: 'MAX_DMA_CHANNELS' undeclared
	status: one of many fixes mips needs...
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6091660/
----------------

parisc:defconfig
	when:	Apr 20
	why:	file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/

parisc:allmodconfig
	when:	?
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228

parisc64:a500_defconfig 
	when:	?
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

sparc/m68k:all
	when:	Apr 18
	why:	fs/gfs2/lops.c:379:42: error: request for member 'virtual' in something not a structure or union
	status:	reported/bisected by PaulG
	ref:	http://marc.info/?l=linux-next&m=133479890929994&w=2
------------------

xtensa:defconfig
	when:	Apr 20
	why:	kallsyms.c:(.text+0x1eb44): undefined reference to `ack_bad_irq'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6138090/
