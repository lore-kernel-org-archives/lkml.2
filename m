Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0IUTcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:32:09 -0400
Received: from szamchat.xatka.net ([195.137.246.111]:22080 "EHLO
	szamchat.xatka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0IUTcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:32:07 -0400
X-Greylist: delayed 1453 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2010 15:32:07 EDT
Date: Tue, 21 Sep 2010 21:05:25 +0200
From: =?iso-8859-2?Q?Pawe=B3?= Zuzelski <pawelz@pld-linux.org>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: lkml <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
        xen-devel@lists.xensource.com
Subject: PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after the boot
Message-ID: <20100921190525.GD4573@davabel.touk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

kernels 2.6.35.5 and 2.6.32.22 xen domU panics at the very begining of the
boot process.

I have bisected it to a single commit, and the first bad commit is:
[fb412a178502dc498430723b082a932f797e4763] xen: use percpu interrupts for IPIs and VIRQs

kernel v2.6.35.5 with reverted this commit works for me.

Here are the kernel configs I was using:
http://carme.pld-linux.org/~pawelz/kernel-2.6.35.5-domU-config
http://carme.pld-linux.org/~pawelz/kernel-2.6.32.22-domU-config
As you can see they are stripped down configs, intended to run in domU only.

I was testing it with the very simple domU configuration:

kernel  = '/srv/xen/bzImage'
memory  = '128'
vcpus = 2
name    = 'test'
on_poweroff = 'destroy'
on_reboot   = 'restart'
on_crash    = 'restart'

Here is the full output of kernel 2.6.35.5:

Using config file "/etc/xen/test".
Started domain test
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: 
[    0.000000] PID hash table entries: 512 (order: 0, 4096 bytes)
[    0.000000] Subtract (33 early reservations)
[    0.000000]   #1 [0001976000 - 0001987000]  XEN PAGETABLES
[    0.000000]   #2 [0001000000 - 00019125f8]   TEXT DATA BSS
[    0.000000]   #3 [0001933000 - 0001976000]  XEN START INFO
[    0.000000]   #4 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #5 [0000012000 - 0000040000]         PGTABLE
[    0.000000]   #6 [0001912600 - 0001917600]       NODE_DATA
[    0.000000]   #7 [0001917600 - 0001918600]         BOOTMEM
[    0.000000]   #8 [0001918600 - 0001918618]         BOOTMEM
[    0.000000]   #9 [0001919000 - 000191a000]         BOOTMEM
[    0.000000]   #10 [000191a000 - 000191b000]         BOOTMEM
[    0.000000]   #11 [000191b000 - 000191c000]         BOOTMEM
[    0.000000]   #12 [0002200000 - 00023c0000]        MEMMAP 0
[    0.000000]   #13 [0001918640 - 00019187c0]         BOOTMEM
[    0.000000]   #14 [000191c000 - 000191cc00]         BOOTMEM
[    0.000000]   #15 [000191d000 - 000191e000]         BOOTMEM
[    0.000000]   #16 [000191e000 - 000191f000]         BOOTMEM
[    0.000000]   #17 [000191f000 - 0001920000]         BOOTMEM
[    0.000000]   #18 [00019187c0 - 00019188a0]         BOOTMEM
[    0.000000]   #19 [00019188c0 - 0001918928]         BOOTMEM
[    0.000000]   #20 [0001918940 - 00019189a8]         BOOTMEM
[    0.000000]   #21 [00019189c0 - 0001918a28]         BOOTMEM
[    0.000000]   #22 [0001918a40 - 0001918a41]         BOOTMEM
[    0.000000]   #23 [0001918a80 - 0001918a81]         BOOTMEM
[    0.000000]   #24 [0001987000 - 00019c1000]         BOOTMEM
[    0.000000]   #25 [0001918ac0 - 0001918ac8]         BOOTMEM
[    0.000000]   #26 [0001918b00 - 0001918b08]         BOOTMEM
[    0.000000]   #27 [0001918b40 - 0001918b48]         BOOTMEM
[    0.000000]   #28 [0001918b80 - 0001918b90]         BOOTMEM
[    0.000000]   #29 [0001918bc0 - 0001918cc0]         BOOTMEM
[    0.000000]   #30 [0001918cc0 - 0001918d08]         BOOTMEM
[    0.000000]   #31 [0001918d40 - 0001918d88]         BOOTMEM
[    0.000000]   #32 [0001920000 - 0001921000]         BOOTMEM
[    0.000000] Memory: 118724k/131072k available (3327k kernel code, 448k absent, 11900k reserved, 3931k data, 440k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled
[    0.000000] installing Xen timer for CPU 0
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at (null)
[    0.000000] IP: [<(null)>] (null)
[    0.000000] PGD 0 
[    0.000000] Oops: 0010 [#1] SMP 
[    0.000000] last sysfs file: 
[    0.000000] CPU 0 
[    0.000000] Modules linked in:
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.35.5 #1 /
[    0.000000] RIP: e030:[<0000000000000000>]  [<(null)>] (null)
[    0.000000] RSP: e02b:ffffffff81601d70  EFLAGS: 00010082
[    0.000000] RAX: ffffffff818fdb50 RBX: 0000000000000000 RCX: 0000000000000000
[    0.000000] RDX: 0000000000000000 RSI: ffffffff818c7958 RDI: 0000000000000000
[    0.000000] RBP: ffffffff81601d88 R08: ffffea00001b22d8 R09: 000000000000001a
[    0.000000] R10: 0000000000000000 R11: 0000000000006477 R12: ffffffff81623280
[    0.000000] R13: 0000000000000000 R14: 00000000ffffffea R15: 0000000000000000
[    0.000000] FS:  0000000000000000(0000) GS:ffff880001987000(0000) knlGS:0000000000000000
[    0.000000] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.000000] CR2: 0000000000000000 CR3: 00000000016b9000 CR4: 0000000000002620
[    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.000000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.000000] Process swapper (pid: 0, threadinfo ffffffff81600000, task ffffffff816c1020)
[    0.000000] Stack:
[    0.000000]  ffffffff8107c849 0000000000000000 ffff880007c0d000 ffffffff81601da8
[    0.000000] <0> ffffffff8107c829 ffffffff8133d3fb ffffffff81623280 ffffffff81601df8
[    0.000000] <0> ffffffff8107c033 ffffffff816202e4 ffffffff816232e4 ffffffff8100572f
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8107c849>] ? default_enable+0x1a/0x28
[    0.000000]  [<ffffffff8107c829>] default_startup+0x19/0x1f
[    0.000000]  [<ffffffff8133d3fb>] ? _raw_spin_lock_irqsave+0xd/0x24
[    0.000000]  [<ffffffff8107c033>] __setup_irq+0x1ab/0x2d8
[    0.000000]  [<ffffffff8100572f>] ? xen_restore_fl_direct_end+0x0/0x1
[    0.000000]  [<ffffffff810052bb>] ? xen_timer_interrupt+0x0/0x17a
[    0.000000]  [<ffffffff8107c278>] request_threaded_irq+0x118/0x146
[    0.000000]  [<ffffffff8125dda5>] bind_virq_to_irqhandler+0x146/0x168
[    0.000000]  [<ffffffff810052bb>] ? xen_timer_interrupt+0x0/0x17a
[    0.000000]  [<ffffffff810055ee>] xen_setup_timer+0x59/0x9d
[    0.000000]  [<ffffffff81731b68>] xen_time_init+0x7b/0x89
[    0.000000]  [<ffffffff81731ead>] x86_late_time_init+0xa/0x11
[    0.000000]  [<ffffffff8172eb49>] start_kernel+0x30b/0x38d
[    0.000000]  [<ffffffff8172e2c6>] x86_64_start_reservations+0xb1/0xb5
[    0.000000]  [<ffffffff817313e8>] xen_start_kernel+0x508/0x50f
[    0.000000] Code:  Bad RIP value.
[    0.000000] RIP  [<(null)>] (null)
[    0.000000]  RSP <ffffffff81601d70>
[    0.000000] CR2: 0000000000000000
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] Pid: 0, comm: swapper Tainted: G      D     2.6.35.5 #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8133bae9>] panic+0x86/0xfa
[    0.000000]  [<ffffffff8103c5c6>] do_exit+0x6d/0x77e
[    0.000000]  [<ffffffff8133d43f>] ? _raw_spin_unlock_irqrestore+0x11/0x13
[    0.000000]  [<ffffffff8103ac55>] ? kmsg_dump+0x11e/0x139
[    0.000000]  [<ffffffff8100b936>] oops_end+0x8f/0x94
[    0.000000]  [<ffffffff810239cc>] no_context+0x1f4/0x203
[    0.000000]  [<ffffffff81023b65>] __bad_area_nosemaphore+0x18a/0x1ad
[    0.000000]  [<ffffffff81023b96>] bad_area_nosemaphore+0xe/0x10
[    0.000000]  [<ffffffff81023f10>] do_page_fault+0x115/0x229
[    0.000000]  [<ffffffff8133daf5>] page_fault+0x25/0x30
[    0.000000]  [<ffffffff8107c849>] ? default_enable+0x1a/0x28
[    0.000000]  [<ffffffff8107c829>] default_startup+0x19/0x1f
[    0.000000]  [<ffffffff8133d3fb>] ? _raw_spin_lock_irqsave+0xd/0x24
[    0.000000]  [<ffffffff8107c033>] __setup_irq+0x1ab/0x2d8
[    0.000000]  [<ffffffff8100572f>] ? xen_restore_fl_direct_end+0x0/0x1
[    0.000000]  [<ffffffff810052bb>] ? xen_timer_interrupt+0x0/0x17a
[    0.000000]  [<ffffffff8107c278>] request_threaded_irq+0x118/0x146
[    0.000000]  [<ffffffff8125dda5>] bind_virq_to_irqhandler+0x146/0x168
[    0.000000]  [<ffffffff810052bb>] ? xen_timer_interrupt+0x0/0x17a
[    0.000000]  [<ffffffff810055ee>] xen_setup_timer+0x59/0x9d
[    0.000000]  [<ffffffff81731b68>] xen_time_init+0x7b/0x89
[    0.000000]  [<ffffffff81731ead>] x86_late_time_init+0xa/0x11
[    0.000000]  [<ffffffff8172eb49>] start_kernel+0x30b/0x38d
[    0.000000]  [<ffffffff8172e2c6>] x86_64_start_reservations+0xb1/0xb5
[    0.000000]  [<ffffffff817313e8>] xen_start_kernel+0x508/0x50f

Additional info:
  arch: x86_64
  cpu:  Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz
  xen:  3.2.1
  dom0: Linux version 2.6.26-2-xen-amd64 (Debian 2.6.26-24lenny1)
		(dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease)
		(Debian 4.1.2-25)) #1 SMP Thu Aug 19 01:12:45 UTC 2010

-- 
Regards,
Pawe³ Zuzelski
