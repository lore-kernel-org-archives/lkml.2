Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1JXQRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab1JXQRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:17:48 -0400
Date: Mon, 24 Oct 2011 18:13:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
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
Message-ID: <20111024161306.GB19659@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com> <20111019215139.GA16395@redhat.com> <20111019215344.GG16395@redhat.com> <20111022072030.GB24475@in.ibm.com> <20111024144127.GA14975@redhat.com> <20111024151614.GA6034@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024151614.GA6034@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Ananth N Mavinakayanahalli wrote:
>
> On Mon, Oct 24, 2011 at 04:41:27PM +0200, Oleg Nesterov wrote:
> >
> > Agreed! it would be nice to "hide" these int3's if we dump the core, but
> > I think this is a bit off-topic. It makes sense to do this in any case,
> > even if the core-dumping was triggered by another thread/insn. It makes
> > sense to remove all int3's, not only at regs->ip location. But how can
> > we do this? This is nontrivial.
>
> I don't think that is a problem.. see below...
>
> > And. Even worse. Suppose that you do "gdb probed_application". Now you
> > see int3's in the disassemble output. What can we do?
>
> In this case, nothing.
>
> > I think we can do nothing, at least currently. This just reflects the
> > fact that uprobe connects to inode, not to process/mm/etc.
> >
> > What do you think?
>
> Thinking further on this, in the normal 'running gdb on a core' case, we
> won't have this problem, as the binary that we point gdb to, will be a
> pristine one, without the uprobe int3s, right?

Not sure I understand.

I meant, if we have a binary with uprobes (iow, register_uprobe() installed
uprobes into that file), then gdb will see int3's with or without the core.
Or you can add uprobe into glibc, say you can probe getpid(). Now (again,
with or without the core) disassemble shows that getpid() starts with int3.

But I guess you meant something else...

Oleg.

