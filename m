Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2LRFgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:36:10 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43127 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2LRFgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:36:09 -0500
Date: Tue, 18 Dec 2012 11:06:03 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>, bigeasy@linutronix.de,
        srikar@linux.vnet.ibm.com, peterz@infradead.org,
        benh@kernel.crashing.org, mingo@elte.hu, anton@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] uprobes/powerpc: Make use of generic routines to
	enable single step
Message-ID: <20121218053603.GB6116@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150946.7727.82735.stgit@suzukikp> <20121214200241.GA27195@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214200241.GA27195@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121805-9360-0000-0000-00000E168763
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 09:02:41PM +0100, Oleg Nesterov wrote:
> On 12/03, Suzuki K. Poulose wrote:
> >
> > Replace the ptrace helpers with the powerpc generic routines to
> > enable/disable single step. We save/restore the MSR (and DCBR for BookE)
> > across for the operation. We don't have to disable the single step,
> > as restoring the MSR/DBCR would restore the previous state.
> 
> Obviously I can't review this series (although it looks fine to me).
> 
> Just one note,
> 
> > @@ -121,7 +132,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> >
> >  	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
> >
> > -	uprobe_restore_context_sstep(&utask->autask);
> > +	uprobe_restore_context_sstep(&utask->autask, regs);
> 
> I am not sure ppc needs this, but note that x86 does a bit more.
> 
> Not only we need to restore the "single-step" state, we need to
> send SIGTRAP if it was not set by us. The same for _skip_sstep.

Do you mean restoring the TF equivalent on powerpc to what it was before?

If so, powerpc has always been unique in this aspect -- the single-step
exception handler *always* resets the sstep bit in MSR. Any user needing
to continue single-stepping has to explicitly set it again.

Ananth

