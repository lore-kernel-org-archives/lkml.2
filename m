Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1JVHVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:21:11 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40748 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab1JVHVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:21:10 -0400
Date: Sat, 22 Oct 2011 12:50:30 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/X] uprobes: introduce UTASK_SSTEP_TRAPPED logic
Message-ID: <20111022072030.GB24475@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com> <20111019215344.GG16395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019215344.GG16395@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
x-cbid: 11102207-5930-0000-0000-0000007E0B1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 11:53:44PM +0200, Oleg Nesterov wrote:
> Finally, add UTASK_SSTEP_TRAPPED state/code to handle the case when
> xol insn itself triggers the signal.
> 
> In this case we should restart the original insn even if the task is
> already SIGKILL'ed (say, the coredump should report the correct ip).
> This is even more important if the task has a handler for SIGSEGV/etc,
> The _same_ instruction should be repeated again after return from the
> signal handler, and SSTEP can never finish in this case.

Oleg,

Not sure I understand this completely...

When you say 'correct ip' you mean the original vaddr where we now have
a uprobe breakpoint and not the xol copy, right?

Coredump needs to report the correct ip, but should it also not report
correctly the instruction that caused the signal? Ergo, shouldn't we
put the original instruction back at the uprobed vaddr?

Ananth

