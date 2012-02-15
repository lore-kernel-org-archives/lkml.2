Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2BOUqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:46:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:54995 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2BOUq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:46:28 -0500
Date: Wed, 15 Feb 2012 21:46:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
In-Reply-To: <20120215203814.GA29795@srcf.ucam.org>
Message-ID: <alpine.LFD.2.02.1202152140110.2794@ionos>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com> <alpine.LFD.2.02.1202151537500.2794@ionos> <20120215145225.GA21448@srcf.ucam.org> <alpine.LFD.2.02.1202152059230.2794@ionos> <20120215202221.GA29552@srcf.ucam.org> <alpine.LFD.2.02.1202152125500.2794@ionos>
 <20120215203814.GA29795@srcf.ucam.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Matthew Garrett wrote:

> On Wed, Feb 15, 2012 at 09:30:20PM +0100, Thomas Gleixner wrote:
> > On Wed, 15 Feb 2012, Matthew Garrett wrote:
> > > Excellent. So the real question is what /should/ sleep(0) do - nothing, 
> > > schedule or sleep for an arbitrary period of time that could be years?
> > 
> > Well, I don't expect slack to be set to years and I really don't want
> > to special case sleep(0), because then we might end up discussing
> > special casing usleep(1) or nanosleep(1ns) as well.
> 
> Increasing slack to the seconds range has measureable power management 
> benefits, but there's some code that ends up broken as a result even 
> when they're nominally event driven. I've no problem with us just 
> declaring that code as broken, but it would be less effort to special 
> case it. Application authors do seem to have ended up under the belief 
> that sleep(0) is a meaningful thing to do, and the internet seems to be 
> full of suggestions to use it rather than sched_yield().

The internet is full of crappy suggestions written by absolutely
clueless and advisory resistant morons.

Dammit, we cannot come up with a reasonable definition for special
casing that stuff simply because you cannot draw a clear boundary what
to special case and what not. And there is no sensible definition for
what to do - return right away or go through schedule() or what ever.

sleep(0) is as pointless as sched_yield() and it's about time that we
stop to create a fucking mess in the kernel just because user space
programmers refuse to understand how an operating system works and how
proper programming should be done.

Thanks,

	tglx
