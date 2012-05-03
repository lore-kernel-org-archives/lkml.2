Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab2ECXYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:24:54 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60732 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab2ECXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:24:51 -0400
Date: Thu, 3 May 2012 19:24:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for May 3, 2012
Message-ID: <20120503232449.GA31066@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New breakage since last report:
  ppc:ppc40x_defconfig
	ppc4xx_msi.c:178:2: error: right shift count >= width of type
  ppc:mpc85xx_defconfig
	hugetlbpage.c:316:4: passing arg 7 of 'parse_args' from incompat type
  arm:spear3xx_defconfig
	spear3xx_clock.c: implicit declaration of function 'clk_register_clkdev'
  arm:nhk8815_defconfig
	gpio-nomadik.c: 'struct gpio_chip' has no member named 'of_node'
  arm:integrator_defconfig
	pci_std_swizzle was deleted, I've sent a fix
  arm:s3c2410_defconfig
	trivial missing header incl.  I've sent a fix.
  blackfin:SMP
	kernel/smp.c:724: undefined reference to `smp_call_function_many'
			
Randconfig fails that may or may not be new (by their very nature):
  <none>

Builds that are fixed since last report:
  -USB err stuff fixed
  -mmotm HUGE_MAX_HSTATE missing define fixed
  -i386 allmodconfig

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

Failures as of May 3rd, 2012:
===============================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:integrator_defconfig
	when:	May 3
	why:	pci_std_swizzle was deleted
	status:	fix sent to arm kernel ML.

ARM:s3c2410_defconfig
	when:	May 3
	why:	s3c2410_wdt.c:517:3: error: implicit declaration of function 'of_match_ptr'
	status:	fix sent to arm kernel ML.

ARM:nhk8815_defconfig
	when:	May 3
	why:	gpio-nomadik.c: 'struct gpio_chip' has no member named 'of_node'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6229016/

ARM:spear3xx_defconfig,spear6xx_defconfig
	when:	May 3
	why:	spear3xx_clock.c: implicit declaration of function 'clk_register_clkdev'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6229026/
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6229027/

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
	when:	Apr 20ish
	why:	usr/include/asm/kvm_para.h:1: included file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228994/

ARM:ezx_defconfig
	when:	Apr 19 (possibly earlier?)
	why:	ezx-pcap.c: implicit declaration of function 'irq_to_gpio'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131924/

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

bfin:SMP
	when	May 1
	why:	kernel/smp.c:724: undefined reference to `smp_call_function_many'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228892/
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

powerpc:mpc85xx_defconfig
	when:	May 3
	why:	powerpc/mm/hugetlbpage.c: passing argument 7 of 'parse_args' from incompatible pointer type
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243069/

powerpc:ppc40x_defconfig
	when:	May 3
	why:	sysdev/ppc4xx_msi.c:178:2: error: right shift count >= width of type
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243038/
------------------

sparc[64]:allyesconfig,allmodconfig
	when:	Apr 18
	why:	usr/include/asm/kvm_para.h: included file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243021/

sparc:allnoconfig
	when:	Apr 20ish
	why:	arch/sparc/mm/init_64.c: unused variable 'paddr' 'node'
	why:	arch/sparc/mm/init_64.c: 'memblock_nid_range' defined but not used
------------------

s390:allyesconfig,allmodconfig
	when:	May 3
	why:	drivers/memory/emif.c:218:2: error: implicit declaration of function 'readl'
	status:	reported
	ref:	https://lkml.org/lkml/2012/5/3/478
------------------

tile:defconfig
	when:	Apr 20ish
	why:	drivers/pci/pci-sysfs.c:421: undefined reference to `vga_default_device'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228983/
------------------

xtensa:defconfig
	when:	Apr 20
	why:	undefined reference to `_sdata'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228970/
