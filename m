Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab1KYGj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 01:39:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1KYGj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 01:39:57 -0500
Subject: Re: [patch 3/7] sched: set skip_clock_update in yield_task_fair()
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1322129545.2921.6.camel@twins>
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
	 <1321971686.6855.18.camel@marge.simson.net>
	 <1322059696.14799.68.camel@twins>
	 <1322106615.6222.10.camel@marge.simson.net> <1322129545.2921.6.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 07:39:31 +0100
Message-ID: <1322203171.8286.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 11:12 +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-24 at 04:50 +0100, Mike Galbraith wrote:
> > On Wed, 2011-11-23 at 15:48 +0100, Peter Zijlstra wrote:
> > > On Tue, 2011-11-22 at 15:21 +0100, Mike Galbraith wrote:
> > > > This is another case where we are on our way to schedule(),
> > > > so can save a useless clock update and resulting microscopic
> > > > vruntime update.
> > > > 
> > > 
> > > Everytime I see one of these skip_clock_update thingies I get the idea
> > > we should do something smarter, because its most fragile and getting it
> > > wrong results in a subtle trainwreck..
> > > 
> > > Would something like the below help in validating this stuff?
> > 
> > No, because switch itself is irrelevant to fair-beans counting.
> 
> Hmm, right, but we can keep another counter that is more relevant, like
> all schedule(),ttwu() and various other calls, right?

Yeah, there's gotta be a way to be smarter about this.  When waking a
gaggle, we'll do useless microscopic updates and preempt checks for each
and every wakeup (not to mention waker can be preempted).  It's one
event per touched rq really, but we treat is as many.  The skip thing
just binds a couple obvious spots in a hacky way.

> Thing is, is that going to be less fragile than the current crap :-(

I agree it's fragile.

	-Mike

