Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1COCDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 22:03:35 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42778 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab1COCDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 22:03:33 -0400
Date: Tue, 15 Mar 2011 07:27:40 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Message-ID: <20110315015739.GS24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314163028.a05cec49.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110314163028.a05cec49.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > 4. Corelating events from kernels and userspace.
> > Uprobes could be used with other tools like kprobes, tracepoints or as
> > part of higher level tools like perf to give a consolidated set of
> > events from kernel and userspace.  In future we could look at a single
> > backtrace showing application, library and kernel calls.
> 
> How do you envisage these features actually get used?  For example,
> will gdb be modified?  Will other debuggers be modified or written?
> 
> IOW, I'm trying to get an understanding of how you expect this feature
> will actually become useful to end users - the kernel patch is only
> part of the story.
> 

Right, So I am looking at having perf probe for uprobes and also at
having a syscall so that perf probe and other ptrace users can use this
infrastructure. Ingo has already asked for a syscall for the same in
one of his replies to my previous patchset. From whatever
discussions I had with ptrace users, they have shown interest in
using this breakpoint infrastructure.

I am still not sure if this feature should be exposed thro a new
operation to ptrace syscall (something like SET_BP) or a completely new
syscall or both. I would be happy if people here could give inputs on
which route to go forward.

We had perf probe for uprobes implemented in few of the previous
patchset. When the underlying implementation changed from a
pid:vaddr to a file:offset, the way we invoke perf probe changed.

Previously we would do 
"perf probe -p 3692 zfree@zsh"

Now we would be doing 
"perf probe -u zfree@zsh"

The perf probe for uprobes is still WIP. Will post the patches when it
is in usable fashion. This should be pretty soon.

If you have suggestions on how this infrastructure could be used
above perf probe and syscall, then please do let me know.

-- 
Thanks and Regards
Srikar
