Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1LBSUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:20:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51195 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1LBSUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:20:11 -0500
Date: Fri, 2 Dec 2011 19:20:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH-RT] Fix for sleeping function called from invalid context when running gdb
Message-ID: <20111202182008.GT24062@one.firstfloor.org>
References: <1322833159-3846-1-git-send-email-jkacur@redhat.com> <1322840763.30977.39.camel@frodo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322840763.30977.39.camel@frodo>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -static inline void preempt_conditional_sti(struct pt_regs *regs)
> > +static inline void preempt_conditional_sti(struct pt_regs *regs, int stack)
> >  {
> > -	inc_preempt_count();
> > +	if (stack)
> > +		inc_preempt_count();

All callers now pass in true I think, so you could eliminate the stack argument.

-Andi

> >  	if (regs->flags & X86_EFLAGS_IF)
> >  		local_irq_enable();
