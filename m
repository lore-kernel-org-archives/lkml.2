Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2H1IMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 04:12:22 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:32254
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab2H1IMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 04:12:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1202hzzz2dh668h839h944hd25hf0ah11b5h1155h)
X-WSS-ID: 0M9GHG6-02-0WZ-02
X-M-MSG: 
Date: Tue, 28 Aug 2012 10:12:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: i386, v3.6-rc3: Kernel panic - not syncing: Fatal exception in
 interrupt
Message-ID: <20120828081206.GG8285@erda.amd.com>
References: <20120827151427.GE8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120827151427.GE8285@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.12 17:14:27, Robert Richter wrote:
> Steven and Ingo,
> 
> while running profiling tests on 32 bit I got a
> 
>  Kernel panic - not syncing: Fatal exception in interrupt

Seems not to be a regression, I could trigger it with v3.5 too.

The problem seems to be oprofile related, full trace below.

Thanks,

-Robert

BUG: unable to handle kernel NULL pointer dereference at 00000040
IP: [<c100422f>] print_context_stack+0x6e/0x8d
*pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in:

Pid: 15531, comm: perl Not tainted 3.5.0-oprofile-i386-standard-g28a33cb #2 Hewlett-Packard HP xw9400 Workstation/0A1Ch
EIP: 0060:[<c100422f>] EFLAGS: 00010097 CPU: 3
EIP is at print_context_stack+0x6e/0x8d
EAX: ffffe000 EBX: 00000040 ECX: f4bd1f94 EDX: 00000040
ESI: f4bd1f94 EDI: f4bd1f94 EBP: f5517ec0 ESP: f5517ea0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 00000040 CR3: 34403000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process perl (pid: 15531, ti=f5516000 task=f4f6bbc0 task.ti=f4bd0000)
Stack:
 000003e8 ffffe000 00001ffc f4b8e380 00000000 00000040 f4bd1f94 c1541178
 f5517ef0 c1003717 c1541178 f5517f04 00000000 f5517edc 00000000 00000000
 f5517ee8 f4bd1f94 f5517fc4 00000001 f5517f1c c12d3ba4 00000000 c1541178
Call Trace:
 [<c1003717>] dump_trace+0x7b/0xa1
 [<c12d3ba4>] x86_backtrace+0x40/0x88
 [<c12d2498>] ? oprofile_add_sample+0x56/0x84
 [<c12d24b7>] oprofile_add_sample+0x75/0x84
 [<c12d48e3>] op_amd_check_ctrs+0x46/0x260
 [<c10328b9>] ? wake_up_worker+0x19/0x1b
 [<c103331a>] ? insert_work+0x58/0x5c
 [<c12d4195>] profile_exceptions_notify+0x23/0x4c
 [<c138b497>] nmi_handle+0x31/0x4a
 [<c102734f>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
 [<c138b559>] do_nmi+0xa9/0x304
 [<c102c2e7>] ? run_timer_softirq+0x2a/0x1f5
 [<c102734f>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
 [<c138ae4d>] nmi_stack_correct+0x28/0x2d
 [<c102734f>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
 [<c10035f7>] ? do_softirq+0x4b/0x7f
 <IRQ> 
 [<c10275cc>] irq_exit+0x35/0x5b
 [<c101689e>] smp_apic_timer_interrupt+0x6c/0x7a
 [<c138abae>] apic_timer_interrupt+0x2a/0x30
Code: 89 fe eb 08 31 c9 8b 45 0c ff 55 ec 83 c3 04 83 7d 10 00 74 0c 3b 5d 10 73 26 3b 5d e4 73 0c eb 1f 3b 5d f0 76 1a 3b 5d e8 73 15 <8b> 13 89 d0 89 55 e0 e8 9d 16 03 00 85 c0 8b 55 e0 75 a6 eb cc 
EIP: [<c100422f>] print_context_stack+0x6e/0x8d SS:ESP 0068:f5517ea0
CR2: 0000000000000040
---[ end trace 0cce5d2b7aa480ce ]---
Kernel panic - not syncing: Fatal exception in interrupt


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

