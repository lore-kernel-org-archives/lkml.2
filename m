Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2CGCnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:43:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:42702 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2CGCnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:43:09 -0500
Date: Tue, 6 Mar 2012 21:43:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for March 6, 2012
Message-ID: <20120307024306.GA18493@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the nature of the commits I've been making lately, when I see
a fail in linux-next, I have to wonder if I somehow caused it by a
header shuffle.  After pouring over the kisskb linux-next results,
I realized that I can't be the only one doing this, and that a triage
summary of the linux-next fails should in theory be useful to a
bunch of people doing similar to what I do.

Quite a few fixes from me in the last while, since once you've done
the triage, you are 95% of the way towards a fix, and so I tried to
capitalize on that.  No guarantees I can sustain that level of
investigation and fixing though.  I expect a "this broke it" type
report (without a fix) is more likely going forward.

In any case, I'm not sure how sustainable this is during a merge
window, but lets start with this for now and see where it goes.
It will inevitably lag the linux-next release by about a day,
since the routine builds take close to that to complete.

If you see an entry that you have updated data for, please do
let me know.  I'd rather report vs. reinvestigate.  If you
think this concept is useful, please also let me know, since
that will no doubt influence whether I spend time on it.

Ideally, if we can keep the kisskb builds as close to 100%
green as possible, then we'll have direct visibility into any
new breakage.  Having builds sit broken for six months only
manages to mask visibility into new breakage issues.  :(

Thanks,
Paul.
---

Latest results at:
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of March 6th, 2012:
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
	status:	WIP (PaulG) - may need rework, or pending integration
	fix:
	ref:	http://marc.info/?l=linux-next&m=133106325903524&w=2

ARM:orion5x_defconfig
	when:	Mar 2, 21:27
	why:	"Inconsistent kallsyms data This is a bug"
	status:	transient?  (but yet three days in a row?)
	fix:	n/a?
	ref:

ARM:em_x270_defconfig
	when:	Feb 14, 01:15
	why:	em-x270.c: unknown field 'dev' specified in initializer
	status:	WIP (PaulG) - I think initial patch needs rework
	fix:	
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
	when:	Nov 17, 16:19
	why:	zsmalloc-main.c:255: error: 'MAX_PHYSMEM_BITS' undeclared
	status:	staging commit, reported to GregKH by PaulG.
	fix:
	ref:
----------------

ia64:defconfig
	when:	Mar 6, 21:44
	why:	PaulG broke lib/string.c: implicit declaration of function 'printk'
	status:	fixed
	fix:	in linux next for Mar7
	ref:	http://marc.info/?l=linux-next&m=133106828606006&w=2
----------------

m68k:***all-builds***
	when:	Mar 6, 21:44
	why:	PaulG broke lib/string.c: implicit declaration of function 'printk'
	status:	fixed
	fix:	in linux next for Mar7
	ref:	http://marc.info/?l=linux-next&m=133106828606006&w=2
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
	ref:	
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
------------------

sh4:***all-builds***
	when:	Feb 24, 17:38
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

sparc:allmodconfig
	when:	Mar 2, 17:53
	why:	drivers/usb/gadget/pch_udc.c: implicit declaration of function 'irq_set_irq_type'
	status:	reported by PaulG, WIP by Tomoya MORINAGA 
	fix:	
	ref:	http://comments.gmane.org/gmane.linux.kernel.next/21060
------------------

sparc64:allmodconfig
	when:	Mar 2, 18:51
	why:	drivers/usb/gadget/pch_udc.c: implicit declaration of function 'irq_set_irq_type'
	status:	reported by PaulG, WIP by Tomoya MORINAGA 
	fix:	
	ref:	http://comments.gmane.org/gmane.linux.kernel.next/21060
------------------

um:um-defconfig
	when:	Sep 16 2010, 01:28
	why:	os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared
	status:	clearly broken forever, so does anyone care?
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/target/2979/
