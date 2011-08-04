Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1HDQkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:40:16 -0400
Received: from gateway.hbm.com ([213.157.30.2]:9607 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1HDQkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:40:10 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 12:40:10 EDT
Thread-Index: AcxSxGRE3fYtdKlSSk+FXWviLqKgIg==
Thread-Topic: [ANNOUNCE] 3.0-rt6 : BUG at kernel/trmutex.c:724!
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt6 : BUG at kernel/trmutex.c:724!
Date: Thu, 4 Aug 2011 18:34:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
In-Reply-To: <alpine.LFD.2.02.1107282213000.31246@ionos>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108041834.20575.tim.sander@hbm.com>
X-OriginalArrivalTime: 04 Aug 2011 16:34:33.0447 (UTC) FILETIME=[642A6770:01CC52C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

I was really happy to find 6 preempt rt releases for the 3.0 kernel after holliday :-).

So i went for a testdrive and found an error: The error occurs in a non released non 
mainline kernel and is available from me upon request. It has been working on 
(2.6.39,3.0) but is not working on 3.0-rt6. It fails in an interrupt which calls: 

wake_up_interruptible(&hbm_device.wait);

The waitque has been initialized with:
init_waitqueue_head(&hbm_device.wait);
before interrupts where enabled. So i don't think its a race.

Will test if the 3.0-rc7 fixes the problem.

Best regards
Tim

Below is the output:
kernel BUG at kernel/rtmutex.c:724!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7148000
[00000000] *pgd=87131831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in: msp fpga canterm i2c_imx netx netx_reset dspload fpgaload mxc_nand nand nand_ids nand_ecc
CPU: 0    Not tainted  (3.0.0-pmx-rt6-00007-g6b68987 #153)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3ec/0x45c
pc : [<c002cbb0>]    lr : [<c003dd58>]    psr: 60000193
sp : c715fcf0  ip : c715fc30  fp : c715fcfc
r10: c0319234  r9 : 00000001  r8 : 00000040
r7 : 00000000  r6 : 00000001  r5 : c787d060  r4 : bf03c6c4
r3 : 00000000  r2 : 00010003  r1 : c715fc30  r0 : 0000002a
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87148008  DAC: 00000015
Process meassrv (pid: 450, stack limit = 0xc715e268)
Stack: (0xc715fcf0 to 0xc7160000)
fce0:                                     c715fd5c c715fd00 c023eb44 c002cb98
fd00: c023f268 c023ed68 c715fd3c c715fd18 c00346c8 c023f264 00000000 c00632b0
fd20: bf03c628 00000001 00000041 00000000 00000000 c02fee01 00000041 bf03c6c4
fd40: 00000001 00000001 00000000 00000040 c715fd6c c715fd60 c023f240 c023ea54
fd60: c715fd94 c715fd70 c00346a8 c023f23c c715fd8c c715fd80 bf03c628 00000001
fd80: 00000041 00000000 c715fdac c715fd98 bf03bb24 c0034690 c7b685a0 c02feef8
fda0: c715fde4 c715fdb0 c006eecc bf03ba70 ffffffff 00000004 000a25a8 c02feef8
fdc0: c7b685a0 c02f9678 00000002 00000040 00000003 00000001 c715fdfc c715fde8
fde0: c006f050 c006eea0 c02feef8 00000002 c715fe14 c715fe00 c00710c4 c006f000
fe00: c0071008 00000001 c715fe24 c715fe18 c006e8d8 c0071014 c715fe54 c715fe28
fe20: c0033210 c006e8b0 ffffffff 00000034 00000000 00340000 00000001 00000000
fe40: c715e000 00000000 c715fe64 c715fe58 c0033250 c003317c c715fe74 c715fe68
fe60: c006e8d8 c0033230 c715fe8c c715fe78 c0024068 c006e8b0 ffffffff f5800000
fe80: c715fee4 c715fe90 c002968c c002400c c0034fe8 c715fe48 c715fe78 00000000
fea0: bf03c6c4 c715ff18 c715ff0c c787d060 00000004 c715e000 00000000 c715fee4
fec0: c715fe18 c715fed8 c002cb70 c023f240 60000013 ffffffff c715ff04 c715fee8
fee0: c0056338 c023f23c c00365cc c715e000 41093914 c715ff0c c715ff3c c715ff08
ff00: bf03b9e0 c005631c 00000001 00000000 c787d060 c00365cc 00000000 00000000
ff20: 00000004 c7114b60 41093914 c715ff70 c715ff6c c715ff40 c009e95c bf03b99c
ff40: c715ff6c c715ff50 c009fab0 c7114b60 41093914 00000000 00000000 00000004
ff60: c715ffa4 c715ff70 c009ea2c c009e8b0 00000000 00000000 c715ff94 00000001
ff80: c0042578 bee199b4 00000000 4109fca8 00000003 c0029c04 00000000 c715ffa8
ffa0: c0029a80 c009e9f4 bee199b4 00000000 00000009 41093914 00000004 bee199b4
ffc0: bee199b4 00000000 4109fca8 00000003 410a0460 bee19934 00000000 4109ff9c
ffe0: 00000000 4108bb48 404e43fc 404e4bc4 80000010 00000009 86bae92e 86fa7a2e
Backtrace: 
[<c002cb8c>] (__bug+0x0/0x30) from [<c023eb44>] (rt_spin_lock_slowlock+0xfc/0x274)
[<c023ea48>] (rt_spin_lock_slowlock+0x0/0x274) from [<c023f240>] (rt_spin_lock+0x10/0x14)
 r8:00000040 r7:00000000 r6:00000001 r5:00000001 r4:bf03c6c4
[<c023f230>] (rt_spin_lock+0x0/0x14) from [<c00346a8>] (__wake_up+0x24/0x4c)
[<c0034684>] (__wake_up+0x0/0x4c) from [<bf03bb24>] (hbm_mmap_irq_handler+0xc0/0x100 [fpga])
 r7:00000000 r6:00000041 r5:00000001 r4:bf03c628
[<bf03ba64>] (hbm_mmap_irq_handler+0x0/0x100 [fpga]) from [<c006eecc>] (handle_irq_event_percpu+0x38/0x160)
 r5:c02feef8 r4:c7b685a0
[<c006ee94>] (handle_irq_event_percpu+0x0/0x160) from [<c006f050>] (handle_irq_event+0x5c/0x7c)
[<c006eff4>] (handle_irq_event+0x0/0x7c) from [<c00710c4>] (handle_level_irq+0xbc/0x108)
 r5:00000002 r4:c02feef8
[<c0071008>] (handle_level_irq+0x0/0x108) from [<c006e8d8>] (generic_handle_irq+0x34/0x48)
 r4:00000001 r3:c0071008
[<c006e8a4>] (generic_handle_irq+0x0/0x48) from [<c0033210>] (mxc_gpio_irq_handler+0xa0/0xb4)
[<c0033170>] (mxc_gpio_irq_handler+0x0/0xb4) from [<c0033250>] (mx3_gpio_irq_handler+0x2c/0x30)
[<c0033224>] (mx3_gpio_irq_handler+0x0/0x30) from [<c006e8d8>] (generic_handle_irq+0x34/0x48)
[<c006e8a4>] (generic_handle_irq+0x0/0x48) from [<c0024068>] (asm_do_IRQ+0x68/0x8c)
[<c0024000>] (asm_do_IRQ+0x0/0x8c) from [<c002968c>] (__irq_svc+0x4c/0x94)
Exception stack(0xc715fe90 to 0xc715fed8)
fe80:                                     c0034fe8 c715fe48 c715fe78 00000000
fea0: bf03c6c4 c715ff18 c715ff0c c787d060 00000004 c715e000 00000000 c715fee4
fec0: c715fe18 c715fed8 c002cb70 c023f240 60000013 ffffffff
 r5:f5800000 r4:ffffffff
[<c023f230>] (rt_spin_lock+0x0/0x14) from [<c0056338>] (add_wait_queue+0x28/0x4c)
[<c0056310>] (add_wait_queue+0x0/0x4c) from [<bf03b9e0>] (hbm_mmap_read+0x50/0xd4 [fpga])
 r6:c715ff0c r5:41093914 r4:c715e000 r3:c00365cc
[<bf03b990>] (hbm_mmap_read+0x0/0xd4 [fpga]) from [<c009e95c>] (vfs_read+0xb8/0x144)
 r7:c715ff70 r6:41093914 r5:c7114b60 r4:00000004
[<c009e8a4>] (vfs_read+0x0/0x144) from [<c009ea2c>] (sys_read+0x44/0x70)
 r8:00000004 r7:00000000 r6:00000000 r5:41093914 r4:c7114b60
[<c009e9e8>] (sys_read+0x0/0x70) from [<c0029a80>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000003 r6:4109fca8 r5:00000000 r4:bee199b4
Code: e59f0010 e1a01003 eb084104 e3a03000 (e5833000) 
---[ end trace 0000000000000002 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Backtrace: 
[<c002cdb8>] (dump_backtrace+0x0/0x110) from [<c023ce34>] (dump_stack+0x18/0x1c)
 r6:00000000 r5:c715fca8 r4:c030f370 r3:00000000
[<c023ce1c>] (dump_stack+0x0/0x1c) from [<c023ce9c>] (panic+0x64/0x188)
[<c023ce38>] (panic+0x0/0x188) from [<c002d2f4>] (die+0x100/0x128)
 r3:00010000 r2:c715fb78 r1:00000001 r0:c02afc9d
 r7:00000817
[<c002d1f4>] (die+0x0/0x128) from [<c002f0a8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c715fca8 r6:c7abae40 r5:00000817 r4:00000000
[<c002f03c>] (__do_kernel_fault+0x0/0x8c) from [<c002f1fc>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c02f9190 r6:c787d060 r5:c7abae40 r4:c715fca8
r3:c715fca8
[<c002f0c8>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc715fca8 to 0xc715fcf0)
fca0:                   0000002a c715fc30 00010003 00000000 bf03c6c4 c787d060
fcc0: 00000001 00000000 00000040 00000001 c0319234 c715fcfc c715fc30 c715fcf0
fce0: c003dd58 c002cbb0 60000193 ffffffff
 r8:00000040 r7:00000000 r6:00000001 r5:c715fcdc r4:ffffffff
[<c002cb8c>] (__bug+0x0/0x30) from [<c023eb44>] (rt_spin_lock_slowlock+0xfc/0x274)
[<c023ea48>] (rt_spin_lock_slowlock+0x0/0x274) from [<c023f240>] (rt_spin_lock+0x10/0x14)
 r8:00000040 r7:00000000 r6:00000001 r5:00000001 r4:bf03c6c4
[<c023f230>] (rt_spin_lock+0x0/0x14) from [<c00346a8>] (__wake_up+0x24/0x4c)
[<c0034684>] (__wake_up+0x0/0x4c) from [<bf03bb24>] (hbm_mmap_irq_handler+0xc0/0x100 [fpga])
 r7:00000000 r6:00000041 r5:00000001 r4:bf03c628
[<bf03ba64>] (hbm_mmap_irq_handler+0x0/0x100 [fpga]) from [<c006eecc>] (handle_irq_event_percpu+0x38/0x160)
 r5:c02feef8 r4:c7b685a0
[<c006ee94>] (handle_irq_event_percpu+0x0/0x160) from [<c006f050>] (handle_irq_event+0x5c/0x7c)
[<c006eff4>] (handle_irq_event+0x0/0x7c) from [<c00710c4>] (handle_level_irq+0xbc/0x108)
 r5:00000002 r4:c02feef8
[<c0071008>] (handle_level_irq+0x0/0x108) from [<c006e8d8>] (generic_handle_irq+0x34/0x48)
 r4:00000001 r3:c0071008
[<c006e8a4>] (generic_handle_irq+0x0/0x48) from [<c0033210>] (mxc_gpio_irq_handler+0xa0/0xb4)
[<c0033170>] (mxc_gpio_irq_handler+0x0/0xb4) from [<c0033250>] (mx3_gpio_irq_handler+0x2c/0x30)
[<c0033224>] (mx3_gpio_irq_handler+0x0/0x30) from [<c006e8d8>] (generic_handle_irq+0x34/0x48)
[<c006e8a4>] (generic_handle_irq+0x0/0x48) from [<c0024068>] (asm_do_IRQ+0x68/0x8c)
[<c0024000>] (asm_do_IRQ+0x0/0x8c) from [<c002968c>] (__irq_svc+0x4c/0x94)
Exception stack(0xc715fe90 to 0xc715fed8)
fe80:                                     c0034fe8 c715fe48 c715fe78 00000000
fea0: bf03c6c4 c715ff18 c715ff0c c787d060 00000004 c715e000 00000000 c715fee4
fec0: c715fe18 c715fed8 c002cb70 c023f240 60000013 ffffffff
 r5:f5800000 r4:ffffffff
[<c023f230>] (rt_spin_lock+0x0/0x14) from [<c0056338>] (add_wait_queue+0x28/0x4c)
[<c0056310>] (add_wait_queue+0x0/0x4c) from [<bf03b9e0>] (hbm_mmap_read+0x50/0xd4 [fpga])
 r6:c715ff0c r5:41093914 r4:c715e000 r3:c00365cc
[<bf03b990>] (hbm_mmap_read+0x0/0xd4 [fpga]) from [<c009e95c>] (vfs_read+0xb8/0x144)
 r7:c715ff70 r6:41093914 r5:c7114b60 r4:00000004
[<c009e8a4>] (vfs_read+0x0/0x144) from [<c009ea2c>] (sys_read+0x44/0x70)
 r8:00000004 r7:00000000 r6:00000000 r5:41093914 r4:c7114b60
[<c009e9e8>] (sys_read+0x0/0x70) from [<c0029a80>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000003 r6:4109fca8 r5:00000000 r4:bee199b4


Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

