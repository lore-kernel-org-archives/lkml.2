Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab1FJPei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:34:38 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40336 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab1FJPeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:34:37 -0400
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, rostedt <rostedt@goodmis.org>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1307717156.3941.169.camel@twins>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 10:34:41 -0500
Message-ID: <1307720081.17297.6.camel@atheurer-w510>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 16:45 +0200, Peter Zijlstra wrote:
> On Fri, 2011-06-10 at 16:11 +0200, Peter Zijlstra wrote:
> > On Fri, 2011-06-10 at 08:17 -0500, Andrew Theurer wrote:
> > > Looks like commit d72bce0e67e8afc6eb959f656013cbb577426f1e breaks my
> > > boot:
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at
> > > 0000000000000004
> > > IP: [<ffffffff8104e8b1>] find_lowest_rq+0xa1/0x150
> > > PGD 0
> > > Oops: 0000 [#1] SMP
> > > CPU 0
> > > Modules linked in:

> > 
> > > 
> > > This is on a Westmere-EX (4 socket, 40 cores)
> > 
> > Hmm, how often does that happen? my wsm-ep (2*6*2) doesn't seem to
> > suffer said problem. I'll try and see if I can spot the boo-boo. Also,
> > happen to have a .config handy?
> 
> Does the below cure things?

I am afraid not:

Linux version 3.0.0-rc2-00251-g7f45e5c-dirty (root@vg-host.linuxperf9025.net) (gcc version 4.4.5 20110214 (Red Hat 4.4.5-6) (GCC) ) #34 SMP Fri Jun 10 10:23:06 CDT 2011
Command line: initrd=vg-host/initramfs.img ro root=UUID=7e96e905-9ec4-45ab-abd4-77d1469d6e5a console=tty0 console=ttyS0,115200 rdshell BOOT_IMAGE=vg-host/vmlinuz
.
.
.
.
NMI watchdog enabled, takes one hw-pmu counter.
 #23
NMI watchdog enabled, takes one hw-pmu counter.
 #24
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
PGD 0
Oops: 0000 [#1] SMP
CPU 0
Modules linked in:

Pid: 1, comm: swapper Not tainted 3.0.0-rc2-00251-g7f45e5c-dirty #34 IBM  -[7145AC1]-/Node 1, Processor Card
RIP: 0010:[<ffffffff8104e8c1>]  [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
RSP: 0018:ffff883732925ca0  EFLAGS: 00010002
RAX: 0000000000000010 RBX: 0000000000000010 RCX: 0000000000000050
RDX: 00000000ffffffff RSI: 0000000000000050 RDI: 0000000000000050
RBP: ffff883732925cd0 R08: ffff8837325b4238 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000012ac0
FS:  0000000000000000(0000) GS:ffff88387f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff883732924000, task ffff8837329234c0)
Stack:
 ffff883732925cd0 0000000000000010 0000000000000010 ffff8837325b4800
 0000000000000000 0000000000000286 ffff883732925cf0 ffffffff8104e9ea
 ffff883732642040 ffff8837325b4040 ffff883732925d40 ffffffff8105ac79
Call Trace:
 [<ffffffff8104e9ea>] select_task_rq_rt+0x7a/0x90
 [<ffffffff8105ac79>] try_to_wake_up+0x119/0x2a0
 [<ffffffff8105ae55>] wake_up_process+0x15/0x20
 [<ffffffff814cc59f>] rcu_cpu_notify+0xd6/0x196
 [<ffffffff814d65e5>] notifier_call_chain+0x55/0x80
 [<ffffffff8108a7be>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff81064590>] __cpu_notify+0x20/0x40
 [<ffffffff814caf5e>] _cpu_up+0xc7/0x10e
 [<ffffffff814cb07c>] cpu_up+0xd7/0xea
 [<ffffffff81c41dfb>] smp_init+0x41/0x96
 [<ffffffff81c227d4>] kernel_init+0x1d6/0x262
 [<ffffffff814dbbc4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81c225fe>] ? do_basic_setup+0x5c/0x5c
 [<ffffffff814dbbc0>] ? gs_change+0x13/0x13
Code: 2a 01 00 48 89 fe 48 8b 04 c5 40 a3 bf 81 4c 89 e2 49 8b 84 07 88 08 00 00 48 83 c0 38 48 89 c7 e8 85 75 0a 00 85 c0 74 ae 89 d8
 0f a3 1c 24 19 d2 85 d2 75 a6 45 0f a3 2c 24 19 c0 41 be ff
RIP  [<ffffffff8104e8c1>] find_lowest_rq+0xa1/0x150
 RSP <ffff883732925ca0>
CR2: 0000000000000000
---[ end trace 050353be83bb766f ]---

-Andrew

