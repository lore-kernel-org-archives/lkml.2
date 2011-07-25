Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab1GYMpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:45:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1GYMpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:45:03 -0400
Date: Mon, 25 Jul 2011 08:44:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
Message-ID: <20110725124451.GA2866@redhat.com>
References: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
 <20110722195340.GF3765@redhat.com>
 <CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 03:34:37PM -0700, ZAK Magnus wrote:
> On Fri, Jul 22, 2011 at 12:53 PM, Don Zickus <dzickus@redhat.com> wrote:
> 
> > So I played with the hardlockup case and I kinda like the timestamp thing.
> > It seems to give useful data.  In fact I feel like I can shrink the
> > hardlockup window, run some tests and see where the latencies are in a
> > system.  The patch itself I think is ok, I'll review on Monday or Tuesday
> > when I get some more free time.
> >
> > However, I ran the softlockup case and the output was a mess.  I think
> > rcu_sched stalls were being detected and as a result it was NMI dumping
> > stack traces for all cpus.  I can't tell if it was your patch or some
> > uncovered bug.
> >
> > I'll dig into on Monday.  Not sure if you were able to see that.
> >
> > Thanks,
> > Don
> >
> I'm not sure what you mean. One problem could be the wording I used.
> For the soft stalls I just called it LOCKUP, mostly to be very showy
> in order to cover that case where it's unclear what exactly is
> happening. This doesn't do much to distinguish soft and hard lockups,
> and I see LOCKUP otherwise seems to refer to hard lockup, so maybe
> that's misleading.

It had nothing to do with the wording.  It was spewing a ton of stack
traces.  Most of them related to rcu_sched stalls which requested stack
traces for each cpu (and the machine I as on had 16 cpus) repeatedly.

So from a user perspective, I just saw a flood of stack traces scroll
across the screen forever for a minute.  It was impossible to determine
what was going on without reviewing the logs once everything calmed down.
That is never a good thing.  It probably has nothing to do with your
patch, but it is something that should be looked at.

I'll try and poke today or tomorrow.

Cheers,
Don
