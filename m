Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1KXKMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:12:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40604 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab1KXKMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:12:33 -0500
Message-ID: <1322129545.2921.6.camel@twins>
Subject: Re: [patch 3/7] sched: set skip_clock_update in yield_task_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Thu, 24 Nov 2011 11:12:25 +0100
In-Reply-To: <1322106615.6222.10.camel@marge.simson.net>
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
	 <1322106615.6222.10.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 04:50 +0100, Mike Galbraith wrote:
> On Wed, 2011-11-23 at 15:48 +0100, Peter Zijlstra wrote:
> > On Tue, 2011-11-22 at 15:21 +0100, Mike Galbraith wrote:
> > > This is another case where we are on our way to schedule(),
> > > so can save a useless clock update and resulting microscopic
> > > vruntime update.
> > > 
> > 
> > Everytime I see one of these skip_clock_update thingies I get the idea
> > we should do something smarter, because its most fragile and getting it
> > wrong results in a subtle trainwreck..
> > 
> > Would something like the below help in validating this stuff?
> 
> No, because switch itself is irrelevant to fair-beans counting.

Hmm, right, but we can keep another counter that is more relevant, like
all schedule(),ttwu() and various other calls, right?

Thing is, is that going to be less fragile than the current crap :-(
