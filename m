Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1KWOVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:21:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab1KWOVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:21:19 -0500
Subject: Re: [patch 4/7] sched: convert rq->avg_idle to rq->avg_event
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1322053030.7041.32.camel@marge.simson.net>
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
	 <1322053030.7041.32.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 15:21:15 +0100
Message-ID: <1322058075.7041.46.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 13:57 +0100, Mike Galbraith wrote:
> On Wed, 2011-11-23 at 13:27 +0100, Peter Zijlstra wrote:

> > Now I'm not saying this all isn't worth it, just saying my brain is
> > having difficulty seeing how it all makes sense :-)
> 
> They make sense only in that one cheap number generator bandaids three
> owies.  It's fugly but effective :)

Addendum:

That number represents scheduler busyness.  If we're "this" busy, it's
not worth entering nohz, there's unlikely to be enough overlap to be
worth going after at the expense of L2 misses fro L3 equipped CPUs, and
we can't afford to futz around with load balancing just now.

"this" is arbitrary, but in the select_idle_sibling() case at least,
it's impossible to know what any wakee will do with the CPU, so you're
stuck with arbitrary no matter what you use to shut the thing off.

	-Mike

