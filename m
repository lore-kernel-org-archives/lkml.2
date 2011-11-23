Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1KWM5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:57:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1KWM5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:57:13 -0500
Subject: Re: [patch 4/7] sched: convert rq->avg_idle to rq->avg_event
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1322051246.14799.58.camel@twins>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629441.7080.15.camel@marge.simson.net>
	 <1321630552.2197.15.camel@twins>
	 <1321971445.6855.14.camel@marge.simson.net>
	 <1321971751.6855.19.camel@marge.simson.net>
	 <1322049330.14799.43.camel@twins>
	 <1322050165.7041.5.camel@marge.simson.net>
	 <1322051246.14799.58.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 13:57:10 +0100
Message-ID: <1322053030.7041.32.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 13:27 +0100, Peter Zijlstra wrote:
> On Wed, 2011-11-23 at 13:09 +0100, Mike Galbraith wrote:
> > On Wed, 2011-11-23 at 12:55 +0100, Peter Zijlstra wrote:
> > > On Tue, 2011-11-22 at 15:22 +0100, Mike Galbraith wrote:
> > > > We update rq->clock only at points of interest to the scheduler.
> > > > Using this distance has the same effect as measuring idle time
> > > > for idle_balance() throttling, and allows other uses as well. 
> > > 
> > > I'm not sure I follow, suppose we're happily context switching away, how
> > > is the avg distance between context switches related to idle time?
> > 
> > Average idle time can't be larger.
> 
> True :-)
> 
> But it can be _much MUCH_ smaller. So the value is a fair upper limit on
> the idle time, but has no relation to the actual idle duration.

Yup, none.

> Now this value seems to be used in 5 to throttle select_idle_sibling(),
> which is again something unrelated to actual idle duration, but also
> unrelated to the avg update_rq_clock() interval.

Yup.  Clock update is a thing we do at sched event-of-interest, so this
seemed like a good spot to create a multi-purpose number.

> In patch 6 we use this value to guestimate if we should enter nohz,
> since its a wild over estimation of the actual idle duration it'll be
> less effective and might not hard much.
> 
> Also, patch 6's use of sched_migration_cost to reflect the nohz
> enter/exit cost is somewhat iffy, but that's another issue.

Yup.

> Now I'm not saying this all isn't worth it, just saying my brain is
> having difficulty seeing how it all makes sense :-)

They make sense only in that one cheap number generator bandaids three
owies.  It's fugly but effective :)

	-Mike

