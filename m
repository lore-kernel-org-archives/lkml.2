Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab2GBUSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:18:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23841 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2GBUSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:18:22 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=kJdmymVegPMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gu6fZOg2AAAA:8 a=qwgQ2_KmP_3XicoRTHgA:9 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120702200322.573660631@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 02 Jul 2012 16:03:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/6] [RFC v3] ftrace/kprobes: Setting up ftrace for kprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the (hopefully) final round of RFCs, for having kprobes use ftrace
as optimization. This round, I did not include Masami's patches that are
on top of this, simply because I posted them twice before with no changes.
I have them still on top of this series, but I'm only posting my set.
The final pull request will also include Masami's.

If you are interested in Masami's changes, you can find them here:

 http://marc.info/?l=linux-kernel&m=133954203218870&w=2
 Patches 7 - 13 are mostly Masami's and some are mine. But none were changed
 in this release. I may post them again after these are reviewed.

This round, I only did the updates that Masami recommended. I did not
modify the ones that he gave his 'Reviewed-by' tag, except to change
the change log to have that tag.

What was changed were:

Patch 3:
  Moved out the x86 changes into patch 5
  Added a SAVED_REGS_IF_SUPPORTED flag, that can be set if the callback
   can handle the regs parameter being NULL. If the ftrace_ops only has
   SAVED_REGS set, it will fail the registering if the arch does not
   support saving regs.

Patch 5:
  Incorporated x86 changes from the previous patch 3.

Patch 6:
  Have i386 restore flags on return of a function trace that saves regs.

Masami,

Can you review those patches (I believe the rest have your Reviewed-by
already). Then I'll add that tag and push for a pull request.

Thanks!

-- Steve


Steven Rostedt (6):
      ftrace: Pass ftrace_ops as third parameter to function trace callback
      ftrace: Consolidate arch dependent functions with 'list' function
      ftrace: Return pt_regs to function trace callback
      ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function tracer
      ftrace/x86: Add separate function to save regs
      ftrace/x86: Add save_regs for i386 function calls

----
 arch/x86/include/asm/ftrace.h     |   47 +++++---
 arch/x86/kernel/entry_32.S        |   56 +++++++++
 arch/x86/kernel/entry_64.S        |   89 ++++++++++++--
 arch/x86/kernel/ftrace.c          |   73 +++++++++++-
 include/linux/ftrace.h            |  138 ++++++++++++++++++++--
 kernel/trace/ftrace.c             |  236 +++++++++++++++++++++++++------------
 kernel/trace/trace_event_perf.c   |    3 +-
 kernel/trace/trace_events.c       |    3 +-
 kernel/trace/trace_functions.c    |   10 +-
 kernel/trace/trace_irqsoff.c      |    3 +-
 kernel/trace/trace_sched_wakeup.c |    3 +-
 kernel/trace/trace_selftest.c     |   20 +++-
 kernel/trace/trace_stack.c        |    3 +-
 13 files changed, 557 insertions(+), 127 deletions(-)
