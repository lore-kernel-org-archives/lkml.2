Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2H0POi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:14:38 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:43265
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab2H0POg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:14:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h944hd25hf0ah11b5h1155h)
X-WSS-ID: 0M9F6C6-02-CGM-02
X-M-MSG: 
Date: Mon, 27 Aug 2012 17:14:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: i386, v3.6-rc3: Kernel panic - not syncing: Fatal exception in
 interrupt
Message-ID: <20120827151427.GE8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven and Ingo,

while running profiling tests on 32 bit I got a

 Kernel panic - not syncing: Fatal exception in interrupt

The remainings of the stackdump are:

  [<c13950ed>] do_nmi+0xa0/0x2ff
  [<c1029dc5>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
  [<c13949e5>] nmi_stack_correct+0x28/0x2d
  [<c1029dc5>] ? ftrace_define_fields_irq_handler_entry+0x45/0x45
  [<c1003601>] ? do_softirq+0x49/0x7f
  <IRQ> 
  [<c102a06f>] irq_exit+0x35/0x5b
  [<c1018f56>] smp_apic_timer_interrupt+0x6c/0x7a
  [<c1394746>] apic_timer_interrupt+0x2a/0x30
  [<c1007026>] ? default_idle+0x56/0x9e
  [<c1007283>] amd_e400_idle+0xc2/0xc4
  [<c10077fc>] cpu_idle+0x4b/0x65
  [<c138b407>] start_secondary+0x18a/0x18f
 Code: 89 fe eb 08 31 c9 8b 45 0c ff 55 ec 83 c3 04 83 7d 10 00 74 0c 3b 5d 10 73 26 3b 5d e4 73 0c eb 1f 3b 5d f0 76 1a 3b 5d e8 73 15 <8b> 13 89 d0 89 55 e0 e8 ad 42 03 00 85 c0 8b 55 e0 75 a6 eb cc
 EIP: [<c1004237>] print_context_stack+0x6e/0x8d SS:ESP 0068:f5521ea0
 CR2: 0000000000000040
 ---[ end trace 366930af65945435 ]---
 Kernel panic - not syncing: Fatal exception in interrupt

Suspected patches are the following:

 $ git shortlog -p --full-diff v3.5..linux/master -- arch/x86/kernel/nmi*
 Ingo Molnar (1):
       Merge commit 'v3.5-rc3' into x86/debug
 
 Li Zhong (1):
       x86/nmi: Clean up register_nmi_handler() usage
 
 Steven Rostedt (2):
       x86: Remove cmpxchg from i386 NMI nesting code
       x86: Save cr2 in NMI in case NMIs take a page fault (for i386)

Do you know already of something similar?

This happened to me the 2nd time now. Will try to reproduce it to get
a complete trace.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

