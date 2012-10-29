Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2J2G7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:59:06 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48574 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2J2G7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:59:04 -0400
Date: Mon, 29 Oct 2012 12:32:15 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes/powerpc: Don't clear TIF_UPROBE in
 do_notify_resume()
Message-ID: <20121029070215.GB4987@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121028173900.GA14621@redhat.com>
 <20121028173925.GA14642@redhat.com>
 <20121029052707.GA3400@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121029052707.GA3400@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102906-7408-0000-0000-000009B96685
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli <ananth@in.ibm.com> [2012-10-29 10:57:07]:

> On Sun, Oct 28, 2012 at 06:39:25PM +0100, Oleg Nesterov wrote:
> 
> Hi Oleg,
> 
> > Cleanup. No need to clear TIF_UPROBE, do_notify_resume() does this.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > ---
> >  arch/powerpc/kernel/signal.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
> > index a2dc757..3b99711 100644
> > --- a/arch/powerpc/kernel/signal.c
> > +++ b/arch/powerpc/kernel/signal.c
> > @@ -158,10 +158,8 @@ static int do_signal(struct pt_regs *regs)
> > 
> >  void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
> 
> But this _is_ do_notify_resume()... I don't see this flag cleared
> anywhere else.
> 
> Did you have something else in mind?

uprobe_notify_resume() itself clears TIF_UPROBES.

This change is already part of -tip but not mainline.
Hence you might have missed it.

> >  {
> > -	if (thread_info_flags & _TIF_UPROBE) {
> > -		clear_thread_flag(TIF_UPROBE);
> > +	if (thread_info_flags & _TIF_UPROBE)
> >  		uprobe_notify_resume(regs);
> > -	}
> > 
> >  	if (thread_info_flags & _TIF_SIGPENDING)
> >  		do_signal(regs);

