Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab2EWBFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:05:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:60839 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025Ab2EWBE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:04:59 -0400
Date: Tue, 22 May 2012 21:04:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for May 22, 2012
Message-ID: <20120523010457.GA4816@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the merge window open, it is as good a time as any to catch up on
the failures in linux-next.  Please have a look to see if any of these
build failures might be related to your commits.

---------------------

New breakage since last report:

	ARM:netx_defconfig (mach-netx/fb.c: redefinition of 'clk_disable')

	ARM:u8500_defconfig (No rule to make `arch/arm/mach-ux500/pins.o')

	ARM:imx_v4_v5_defconfig (video/mx2_camera.c: 'pixfmt' undeclared)

	ARM:tegra_defconfig  (tegra-smmu.c: implicit decl 'of_get_dma_window')

	blackfin: (implicit declaration of function 'UART_PUT_CLK')

	ia64: (kernel/sched/numa.c: initializer element is not constant)

	sh4: (kernel/process.c:23: implicit decl of function 'unlazy_fpu')


Randconfig fails that may or may not be new (by their very nature):
	i386: include/asm/uaccess_32.h: call to 'copy_from_user_overflow'
		declared with attribute error: copy_from_user() buffer size
		is not provably correct [fs/binfmt_misc.o] Error 1


Builds that are fixed since last report:
	ARM:badge4_defconfig,jornada720_defconfig,neponset_defconfig,cm_x2xx_defconfig 
		arch/arm/common/dmabounce.c: 'generic_dma_map_sg' undeclared

	ARM:integrator_defconfig "implicit decl of function 'pci_std_swizzle'

	ARM:at91x40_defconfig 
		arch/arm/mm/dma-mapping.c: 'pgprot_kernel' undeclared

	ARM:mv78xx0_defconfig
		mach-mv78xx0/pcie.c:256:29: error: 'bus' undeclared

	ARM:xcep_defconfig,marzen_defconfig
		fs/inode.c:1777:6: error: redefinition of 'inode_dio_wait'

	frv: static declaration of 'alloc_task_struct_node' follows non-static

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
	http://kisskb.ellerman.id.au/linux-next

Failures as of this report:
===========================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:imx_v4_v5_defconfig:
	when:	May 21
	why:	video/mx2_camera.c: 'pixfmt' undeclared
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6342390/

ARM:u8500_defconfig
	when:	May sometime
	why:	No rule to make `arch/arm/mach-ux500/pins.o'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6348609/

ARM:at91x40_defconfig 
	when:	May10
	why:	arch/arm/mm/dma-mapping.c: 'pgprot_kernel' undeclared
	status:	bisected and reported (see linux-next mail)
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6291233/

ARM:mv78xx0_defconfig
	when:	May 4
	why:	mach-mv78xx0/pcie.c:256:29: error: 'bus' undeclared
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243629/

ARM:bcmring_defconfig
	when:	Apr 20ish
	why:	usr/include/asm/kvm_para.h:1: included file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228994/

ARM:ezx_defconfig
	when:	Apr 19 (possibly earlier?)
	why:	ezx-pcap.c: implicit declaration of function 'irq_to_gpio'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131924/

ARM:netx_defconfig
	when:	May sometime
	why:	arch/arm/mach-netx/fb.c: redefinition of 'clk_disable'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6348432/

ARM:netx_defconfig,pnx4008_defconfig 
	when:	Mar 14
	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
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
	ref:	http://www.gossamer-threads.com/lists/linux/kernel/1291618?do=post_view_threaded#1291618

----------------

AVR32:allnoconfig
	when:	May 26 2010, 20:49
	why:	at32_map_usart: undefined reference to `atmel_default_console_device'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6248032/
---------------
blackfin:
	when:	May 21
	why:	implicit declaration of function 'UART_PUT_CLK'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6342312/

blackfin: 50% of builds
	when:	Mar 31
	why:	"Error: pcrel too far BFD_RELOC_BFIN_10" from kernel/time/timekeeping.c
	status:	unknown, binutils issue?
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6087324/

blackfin:SMP
	when	May 1
	why:	kernel/smp.c:724: undefined reference to `smp_call_function_many'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228892/
---------------

cris:etrax-100lx_defconfig
	when:	May 7
	why:	drivers/tty/serial/crisv10.c: macro "wait_event_interruptible_tty" requires 3 args,  only 2 given
	why:	drivers/tty/serial/crisv10.c: 'wait_event_interruptible_tty' undecl

cris:allyesconfig,allmodconfig
	when:	Apr 3
	why:	too many to list here
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035250/
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035249/
----------------

ia64: defconfig
	when:	
	why:	kernel/sched/numa.c:21: initializer element is not constant
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6342563/
----------------

i386:allmodconfig
	when:	May11
	why:	input/misc/twl6040-vibra.c: implicit decl 'of_property_read_u32
	status:	reported on linux-next ; needs a Kbuild arch dependency

i386:allnoconfig
	when:	May11
	why:	perf_event_amd.c:(.text+0xc0b0): undefined reference to `get_ibs_caps'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6291419/
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
	ref:	http://www.spinics.net/lists/linux-parisc/msg04100.html
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228

parisc64:a500_defconfig 
	when:	?
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

powerpc:allmodconfig
	when:	May 11
	why:	ERROR: ".of_mdio_find_bus" [phy/mdio-mux.ko] undefined!
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6291463/

------------------

sh4:allnoconfig
	when:	May 22
	why:	kernel/process.c:23: implicit decl of function 'unlazy_fpu'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6342503/

sh4:edosk7705_defconfig
	when:	May 9
	why:	kernel/printk.c:1423: 'LOG_LINE_MAX' undeclared 
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6276831/
------------------

sparc:defconfig
	when:	May 22
	why:	sparc/kernel/time_32.c: inval use undef type 'struct clock_event_device'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243021/	

sparc[64]:allyesconfig,allmodconfig
	when:	Apr 18
	why:	usr/include/asm/kvm_para.h: included file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243021/

sparc:allnoconfig
	when:	May 22
	why:	arch/sparc/kernel/time_32.c: invalid use of undef 'struct clock_event_device'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6348424/
------------------

tile:defconfig
	when:	May 22
	why:	include/asm-generic/unistd.h:695: 'compat_sys_ms_mbind' undeclared here
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6348989/
------------------

xtensa:defconfig
	when:	Apr 20
	why:	undefined reference to `_sdata'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228970/
