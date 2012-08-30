Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2H3Isa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 04:48:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44158 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2H3Is2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 04:48:28 -0400
Date: Thu, 30 Aug 2012 14:17:24 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH v3] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120830084724.GC27415@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120809044356.GA3163@in.ibm.com> <20120809170953.GA27835@linutronix.de> <20120813132443.GB5269@redhat.com> <502A0C43.2000906@linutronix.de> <20120814142736.GA8123@redhat.com> <20120820104734.GA17034@linutronix.de> <20120822140337.GB28878@redhat.com> <5034E8A5.2060701@linutronix.de> <20120822155943.GA4237@redhat.com> <20120829173748.GA1121@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829173748.GA1121@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083008-6148-0000-0000-000009112554
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 07:37:48PM +0200, Oleg Nesterov wrote:
> On 08/22, Oleg Nesterov wrote:
> >
> > > Ehm. Is there anything I missed to do? Or are you speculating on
> > > changes which will clash with these here?
> >
> > If we have task_set_blockstep(), then perhaps it mmakes sense to
> > avoid user_enable_singlestep()/TIF_SINGLESTEP from the start.
> > We will see.
> 
> But it is not clear when we will have task_set_blockstep.
> 
> So I am starting to think it would be better to apply your 1-2 and
> change the code later. Still not correct, but better than nothing.
> 
> 
> 
> But. The more I think about the current code, the more I dislike it.
> And I am starting to think we do not need yet another "weak arch*"
> hook for single-stepping. Yes, it was me who suggested it, but this
> is because I didn't want to complicate the merging of powerpc port.
> 
> However.
> 
> Ananth, Sebastian, what if we start with the patch below? Then
> we can change arch/x86/kernel/uprobes.c to use the static
> uprobe_*_step() helpers from the 2nd patch.

In principle I am fine with the change.

> If we agree this code should be per-arch, then why do need other
> hooks? This is just ugly, we already have arch_pre/post_xol.
> 
> The only problem is the pending powerpc patches, the change below
> obviously breaks them. Were they already applied? If not, then
> probably Ananth can do v6 on top of the patch below ;) The necessary
> fixup is trivial.

They are under review. I can do the change, but since this change is
trivial enough, unless there is a pressing need to move the
user_*_single_step() right away, can't we hold off till 3.6? This can be
a simple enough cleanup then.

If not, I can spin a v6....

Ananth

