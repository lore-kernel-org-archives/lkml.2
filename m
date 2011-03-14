Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab1CNXb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:31:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab1CNXb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:31:56 -0400
Date: Mon, 14 Mar 2011 16:30:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20]  0: Inode based uprobes
Message-Id: <20110314163028.a05cec49.akpm@linux-foundation.org>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 19:04:03 +0530
Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> Advantages of uprobes over conventional debugging include:
> 
> 1. Non-disruptive.
> Unlike current ptrace based mechanisms, uprobes tracing wouldnt
> involve signals, stopping threads and context switching between the
> tracer and tracee.
> 
> 2. Much better handling of multithreaded programs because of XOL.
> Current ptrace based mechanisms use single stepping inline, i.e they
> copy back the original instruction on hitting a breakpoint.  In such
> mechanisms tracers have to stop all the threads on a breakpoint hit or
> tracers will not be able to handle all hits to the location of
> interest. Uprobes uses execution out of line, where the instruction to
> be traced is analysed at the time of breakpoint insertion and a copy
> of instruction is stored at a different location.  On breakpoint hit,
> uprobes jumps to that copied location and singlesteps the same
> instruction and does the necessary fixups post singlestepping.
> 
> 3. Multiple tracers for an application.
> Multiple uprobes based tracer could work in unison to trace an
> application. There could one tracer that could be interested in
> generic events for a particular set of process. While there could be
> another tracer that is just interested in one specific event of a
> particular process thats part of the previous set of process.
> 
> 4. Corelating events from kernels and userspace.
> Uprobes could be used with other tools like kprobes, tracepoints or as
> part of higher level tools like perf to give a consolidated set of
> events from kernel and userspace.  In future we could look at a single
> backtrace showing application, library and kernel calls.

How do you envisage these features actually get used?  For example,
will gdb be modified?  Will other debuggers be modified or written?

IOW, I'm trying to get an understanding of how you expect this feature
will actually become useful to end users - the kernel patch is only
part of the story.


