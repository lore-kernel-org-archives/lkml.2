Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0KHNjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:39:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab0KHNjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:39:39 -0500
Date: Mon, 8 Nov 2010 08:38:51 -0500
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        sergey.senozhatsky@gmail.com
Subject: Re: [PATCH] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-ID: <20101108133851.GK4823@redhat.com>
References: <1288919932-1857-1-git-send-email-dzickus@redhat.com>
 <20101107220909.GF11134@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107220909.GF11134@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 11:09:11PM +0100, Frederic Weisbecker wrote:
> > +	/*
> > +	 * Using __raw here because some code paths have
> > +	 * preemption enabled.  If preemption is enabled
> > +	 * then interrupts should be enabled too, in which
> > +	 * case we shouldn't have to worry about the watchdog
> > +	 * going off.
> > +	 */
> > +	__raw_get_cpu_var(watchdog_nmi_touch) = true;
> > +
> > +	touch_softlockup_watchdog();
> > +}
> > +EXPORT_SYMBOL(touch_nmi_watchdog);
> 
> 
> 
> Did the old watchdog also touched every CPUs?

Yeah, unfortunately.

Cheers,
Don
