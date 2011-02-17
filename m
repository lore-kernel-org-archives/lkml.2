Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1BQGXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 01:23:19 -0500
Received: from 1wt.eu ([62.212.114.60]:60605 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1BQGXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 01:23:17 -0500
Date: Thu, 17 Feb 2011 07:22:28 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Jiri Slaby <jirislaby@gmail.com>, gregkh@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, srostedt <srostedt@redhat.com>,
        stable-commits@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        ghaskins@novell.com, stable@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [stable] Patch "sched: Give CPU bound RT tasks preference" has been added to the 2.6.32-longterm tree
Message-ID: <20110217062228.GA5890@1wt.eu>
References: <12978046423644@kroah.org> <1297810967.23343.122.camel@gandalf.stny.rr.com> <1297821667.5126.11.camel@marge.simson.net> <20110216082559.GA16529@elte.hu> <4D5B90E8.6080605@gmail.com> <1297849553.5275.29.camel@marge.simson.net> <20110216152906.75d4000c@stein> <1297919107.6361.59.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297919107.6361.59.camel@marge.simson.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Feb 17, 2011 at 06:05:07AM +0100, Mike Galbraith wrote:
> That's the intent of pushing more than _purely_ critical bugfixes, get a
> bit closer.  Enterprise can't move as fast as mainline, not even close,
> that's a given.  Stable problem get griped about though, so there's no
> choice but to take some risk.  The tricky bit is how much, and how you
> go about it.
> 
> People are fixing this and that in their enterprise kernels privately
> every day.  The only difference between that, and pushing baked fixes
> back is that pushing to stable is visible.  I strongly suspect that
> there are just tons of mainline backports sitting in each and every
> enterprise tree in existence.  They could have been pushed to stable,
> with _less_ stability risk, due to the higher visibility.

I can confirm that my local 2.6.27 tree has had a quite number of sched
updates that were posted by Ingo, Peter or You in the last two years,
and I'll definitely be considering your work for future updates. However
we must be very careful about what we include in -stable. Its primary
purpose precisely is to let every user upgrade without checking what was
merged because we are responsible for ensuring there is no regression. I
would say it's already a bit late in the 2.6.32 cycle for that but we're
in the first half of its lifecycle and it has a lot of users, so that
would still benefit a lot of people. Let's just hope it will not break
any workload (eg: double the time it takes for a specific task) otherwise
-stable and -longterm will lose some trust among enterprise users.

Ideally we should just make a stable release with just enhancements
from time to time, without important fixes so that people can revert
to the previous one and alert us in case of trouble. But my feeling
is that the current version more or less matches that goal, I don't
remember having seen anything really critical in it that can't be
reverted in case of trouble.

So let's have it, tell users to report any issue and move on :-)

Regards,
Willy

