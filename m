Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab2LRTOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:14:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2LRTOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:14:04 -0500
Date: Tue, 18 Dec 2012 20:10:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>, bigeasy@linutronix.de,
        srikar@linux.vnet.ibm.com, peterz@infradead.org,
        benh@kernel.crashing.org, mingo@elte.hu, anton@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] uprobes/powerpc: Make use of generic routines
	to enable single step
Message-ID: <20121218191013.GA26913@redhat.com>
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150946.7727.82735.stgit@suzukikp> <20121214200241.GA27195@redhat.com> <20121218053603.GB6116@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218053603.GB6116@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Ananth N Mavinakayanahalli wrote:
>
> On Fri, Dec 14, 2012 at 09:02:41PM +0100, Oleg Nesterov wrote:
> > >
> > > -	uprobe_restore_context_sstep(&utask->autask);
> > > +	uprobe_restore_context_sstep(&utask->autask, regs);
> >
> > I am not sure ppc needs this, but note that x86 does a bit more.
> >
> > Not only we need to restore the "single-step" state, we need to
> > send SIGTRAP if it was not set by us. The same for _skip_sstep.
>
> Do you mean restoring the TF equivalent on powerpc to what it was before?
>
> If so, powerpc has always been unique in this aspect -- the single-step
> exception handler *always* resets the sstep bit in MSR. Any user needing
> to continue single-stepping has to explicitly set it again.

I meant another thing.

Suppose that, say, gdb tries to single-step over the probed insn.
In this case we need to send SIGTRAP after xol/emulate. Please look at
send_sig(SIGTRAP) in arch/x86/kernel/uprobes.c:arch_uprobe_post_xol()
and arch_uprobe_skip_sstep().

Oleg.

