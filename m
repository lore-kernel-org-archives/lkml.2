Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2BBP7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:59:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619Ab2BBP7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:59:05 -0500
Date: Thu, 2 Feb 2012 10:58:41 -0500
From: Don Zickus <dzickus@redhat.com>
To: TAO HU <tghk48@motorola.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: In many cases softlockup can not be reported after disabling IRQ
 for long time
Message-ID: <20120202155841.GO5650@redhat.com>
References: <CAOwKts8zS1rYA+Y4k-vb8YAaR=aFd1BwryhhWWnWLQyrYrNqyA@mail.gmail.com>
 <20120131154748.GA5650@redhat.com>
 <CAOwKts_dTvc4LiCZUXN9oYzty1pkDEn_VQwPKY=EoVzk0n6tFA@mail.gmail.com>
 <20120201145802.GF5650@redhat.com>
 <CAOwKts8S0EkUGcP3rYqZe+HdvyXD0+SR1f_3xWpu5FprKWuGhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOwKts8S0EkUGcP3rYqZe+HdvyXD0+SR1f_3xWpu5FprKWuGhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 04:17:02PM +0800, TAO HU wrote:
> Hi, Don
> 
> My concern is not actually that the softlockup could not be reported
> while the IRQ is disabled.
> What bothering me is that even AFTER re-enable the IRQ, it will not
> give warning in many cases.
> 
> In theory, disabling IRQ for long time (10s in my case) also implies
> the high priority thread (watchdog) is blocked
> as well.
> So the ideal case is that softlockup driver could give warning right
> after the IRQ is re-enabled.
> It does so occasionally but fails to be consistent.

The only thing I can think of is that the clock/jiffies isn't updated
until after the hrtimer is run.  I'm not sure if there is any guarantee
for ordering once interrupts are enabled.

But that is just a guess.

I guess in theory, I would expect that when interrupts are enabled, the
system would immediately jump into an IRQ context, update the
clock/jiffies, then run all the other irq handlers like hrtimers, which
would see the new time and do the right thing.  After everything is done,
the system would return to your test code and re-enable preemption
allowing the softlockup thread to run again.

I could be very wrong though. :-)

Cheers,
Don
