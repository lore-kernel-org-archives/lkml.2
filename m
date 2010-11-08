Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0KHNik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:38:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab0KHNij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:38:39 -0500
Date: Mon, 8 Nov 2010 08:37:45 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, fweisbec@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-ID: <20101108133745.GJ4823@redhat.com>
References: <1288919932-1857-1-git-send-email-dzickus@redhat.com>
 <20101105135117.GA27712@swordfish.minsk.epam.com>
 <20101105125855.20e5ce4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105125855.20e5ce4c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 12:58:55PM -0700, Andrew Morton wrote:
> On Fri, 5 Nov 2010 15:51:18 +0200
> Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> 
> > On (11/04/10 21:18), Don Zickus wrote:
> > >  void touch_nmi_watchdog(void)
> > >  {
> > > +	/*
> > > +	 * Using __raw here because some code paths have
> > > +	 * preemption enabled.  If preemption is enabled
> > > +	 * then interrupts should be enabled too, in which
> > > +	 * case we shouldn't have to worry about the watchdog
> > > +	 * going off.
> > > +	 */
> > > +	__raw_get_cpu_var(watchdog_nmi_touch) = true;
> > > +
> > > +	touch_softlockup_watchdog();
> > > +}
> > > +EXPORT_SYMBOL(touch_nmi_watchdog);
> > > +
> > > +void touch_all_nmi_watchdogs(void)
> > > +{
> > >  	if (watchdog_enabled) {
> > >  		unsigned cpu;
> > >  
> > > @@ -151,7 +166,7 @@ void touch_nmi_watchdog(void)
> > >  	}
> > >  	touch_softlockup_watchdog();
> > >  }
> > > -EXPORT_SYMBOL(touch_nmi_watchdog);
> > > +EXPORT_SYMBOL(touch_all_nmi_watchdogs);
> > >  
> > 
> > Hello,
> > Seems like no one is actually calling touch_all_nmi_watchdogs, as for now. 
> > Right?
> 
> Yes, there doesn't seem a lot of point in adding the interface unless
> we have callers.

Yeah I wasn't sure how to deal with that.  It didn't seem like any of the
callers was relying on the fact that touch_nmi_watchdog() touched
everyone.  I just provided it as an option in case I misread someone's use
of the touch_nmi_watchdog.

I'll repost and remove it then.

Thanks for the feedback.

Cheers,
Don
