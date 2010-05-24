Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab0EYHwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:52:13 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41195 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754307Ab0EYHwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:52:11 -0400
Date: Mon, 24 May 2010 23:24:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paul Walmsley <paul@pwsan.com>, Arve Hj?nnev?g <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>, Beno?t Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100524212450.GB1286@ucw.cz>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
 <Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > There are several general problems with the design of opportunistic
> > suspend and suspend-blocks.
> > 
> > 1. The opportunistic suspend code bypasses existing Linux kernel code,
> >    such as timers and the scheduler, that indicates when code
> >    needs to run, and when the system is idle.
> 
> Whoa!  That's not my understanding at all.
> 
> As I see it, opportunistic suspend doesn't bypass any code that isn't 
> already bypassed by the existing suspend code.  Users can do
> 
> 	echo mem >/sys/power/state
> 
> whenever they want, without regard to kernel timers and the scheduler 
> (other than the fact that the user's thread must be running in order to 
> carry out the write, of course).

Yep. And while I'm co-responsible for that interface, I would not
call it exactly nice. Yes, it does the job.

But imagine horrors atd/cron would have to do to work properly with
that interface... setting rtc wakeups etc.

So yes, mem > state already breaks promises, but lets not extend that.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
