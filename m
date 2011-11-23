Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1KWM1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:27:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35648 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1KWM1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:27:35 -0500
Message-ID: <1322051246.14799.58.camel@twins>
Subject: Re: [patch 4/7] sched: convert rq->avg_idle to rq->avg_event
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Wed, 23 Nov 2011 13:27:26 +0100
In-Reply-To: <1322050165.7041.5.camel@marge.simson.net>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 13:09 +0100, Mike Galbraith wrote:
> On Wed, 2011-11-23 at 12:55 +0100, Peter Zijlstra wrote:
> > On Tue, 2011-11-22 at 15:22 +0100, Mike Galbraith wrote:
> > > We update rq->clock only at points of interest to the scheduler.
> > > Using this distance has the same effect as measuring idle time
> > > for idle_balance() throttling, and allows other uses as well. 
> > 
> > I'm not sure I follow, suppose we're happily context switching away, how
> > is the avg distance between context switches related to idle time?
> 
> Average idle time can't be larger.

True :-)

But it can be _much MUCH_ smaller. So the value is a fair upper limit on
the idle time, but has no relation to the actual idle duration.

Now this value seems to be used in 5 to throttle select_idle_sibling(),
which is again something unrelated to actual idle duration, but also
unrelated to the avg update_rq_clock() interval.

In patch 6 we use this value to guestimate if we should enter nohz,
since its a wild over estimation of the actual idle duration it'll be
less effective and might not hard much.

Also, patch 6's use of sched_migration_cost to reflect the nohz
enter/exit cost is somewhat iffy, but that's another issue.


Now I'm not saying this all isn't worth it, just saying my brain is
having difficulty seeing how it all makes sense :-)

Anyway, I picked up 1,2,3,7 and will give the missing patches another
stare a bit later.
