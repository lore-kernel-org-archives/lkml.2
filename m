Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab1I2D1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 23:27:18 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36906 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1I2D1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 23:27:17 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: John Stultz <john.stultz@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1317197974.5781.29.camel@twins>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
	 <1317197974.5781.29.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 20:27:05 -0700
Message-ID: <1317266825.3112.794.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:19 +0200, Peter Zijlstra wrote:
> On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> > > That's just insane.. why bother running anything but the 'important'
> > > tasks. Idle is more power aware than running random crap tasks that have
> > > no business running in the first place.
> > 
> > Its really not that different conceptually from aligning timers. Making
> > sure that when we fire, we expire as many timers as we can in one go,
> > and run all the tasks that need to run, so we can go back to idle for as
> > long as possible.
> > 
> > But instead of idling "until the next timer group", we split stuff we
> > don't care that much about (but needs to be there), and stuff we do care
> > about, and only schedule the hardware to fire for the events we do care
> > about. 
> 
> But but but, my badly coded bouncing cows thing simply doesn't need to
> run when we wake up to refill the sound buffers for the mp3 player while
> the screen is still off!
> 
> Yet the wakelock thing will wake the system and lets us schedule
> bouncing cows just fine..

You're right. While the sound buffers are being refilled, there might be
idle cycles that the wasteful bouncing cow app gets to run during.

And I'm also not disagreeing that blocking draw events from the
framework if the screen is off would be smart.

But I think there's a difference between wasteful bouncing cow app, and
the normal everyday background tasks that run on a standard linux
system.

> I really don't get your argument. It just doesn't make any sense. What
> I'm saying is, what about those apps we really don't care about, and
> really don't need to be there.

I just think that we need a way to block the background noise of normal
systems, so there should be some way for the kernel to distinguish
between background noise and not.

thanks
-john


