Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1EZKzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:55:42 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54343 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173Ab1EZKzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:55:41 -0400
Date: Thu, 26 May 2011 11:55:39 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, "Brown, Len" <lenb@kernel.org>
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
Message-ID: <20110526105527.GA27748@console-pimps.org>
References: <1306398857.2207.157.camel@rui>
 <1306403003.1200.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306403003.1200.41.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:43:23AM +0200, Peter Zijlstra wrote:
>
> That's just wrong.. the reason you're wanting to have this timer is to
> avoid the RAPL MSRs from overflowing and you loosing offsets, right?
> 
> But the above is actually forcing the event to create samples on a
> totally unrelated time base.
> 
> RAPL should fail to create a sampling event since it doesn't have the
> capability to trigger overflow interrupts based on its events.
> 
> If you want a timer, add one, but don't do this.
> 
> If you expect you actually want to sample, use this event as part of a
> group and add a sampling event in there and use PERF_FORMAT_GROUP, Matt
> was working on patches to make perf-record capable of this.

Yep, I have some unfinished patches around here somewhere...

*rummage*

OK, they're in this repository on the perf/group-events branch,

    git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/sh-2.6.git

Obviously since I last touched them in November of last year they're
more than likely not going to apply cleanly to tip, and perhaps more
importantly, I don't think I ever submitted them to LKML for review.

Rui, I'll try to look at your patch series over the weekend and get my
sampling patches into a state where they can be submitted for review
and used by the intel_rapl driver. Does that sound OK?

Or if you want to take a more proactive approach, you're welcome to
finish and submit them ;-)

--
Matt Fleming, Intel Open Source Technology Center
