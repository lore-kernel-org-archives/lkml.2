Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1I1IUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:20:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48645 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1I1IU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:20:29 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 28 Sep 2011 10:19:34 +0200
In-Reply-To: <1317164216.3112.711.camel@work-vm>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317197974.5781.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> > That's just insane.. why bother running anything but the 'important'
> > tasks. Idle is more power aware than running random crap tasks that have
> > no business running in the first place.
> 
> Its really not that different conceptually from aligning timers. Making
> sure that when we fire, we expire as many timers as we can in one go,
> and run all the tasks that need to run, so we can go back to idle for as
> long as possible.
> 
> But instead of idling "until the next timer group", we split stuff we
> don't care that much about (but needs to be there), and stuff we do care
> about, and only schedule the hardware to fire for the events we do care
> about. 

But but but, my badly coded bouncing cows thing simply doesn't need to
run when we wake up to refill the sound buffers for the mp3 player while
the screen is still off!

Yet the wakelock thing will wake the system and lets us schedule
bouncing cows just fine..

I really don't get your argument. It just doesn't make any sense. What
I'm saying is, what about those apps we really don't care about, and
really don't need to be there.
