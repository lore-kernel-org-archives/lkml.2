Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2AYQjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:39:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab2AYQjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:39:04 -0500
Date: Wed, 25 Jan 2012 17:31:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 1/9] uprobes: Install and remove breakpoints.
Message-ID: <20120125163151.GA9242@redhat.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com> <20120110114831.17610.88468.sendpatchset@srdronam.in.ibm.com> <CAK1hOcMVQN4sQjMnV3YBtd6hi8ZtbxPuguVHGxGgSPGn2scsNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcMVQN4sQjMnV3YBtd6hi8ZtbxPuguVHGxGgSPGn2scsNQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25, Denys Vlasenko wrote:
>
> On Tue, Jan 10, 2012 at 12:48 PM, Srikar Dronamraju
> <srikar@linux.vnet.ibm.com> wrote:
> > +/*
> > + * opcodes we'll probably never support:
> > + * 6c-6d, e4-e5, ec-ed - in
> > + * 6e-6f, e6-e7, ee-ef - out
> > + * cc, cd - int3, int
>
> I imagine desire to set a breakpoint on int 0x80 will be rather typical.
> (Same for sysenter).

May be uprobes will support this later. But imho we should not
try to do this now.

With the current code, afaics we do not want to allow the
UTASK_SSTEP/TIF_SINGLESTEP task to enter the kernel mode,
this state is "too special". Just for example, suppose it
clones another task and the child gets the invalid uprobe
state.

Oleg.

