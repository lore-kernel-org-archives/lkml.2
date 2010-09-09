Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0IIVcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:32:09 -0400
Received: from www.tglx.de ([62.245.132.106]:44438 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab0IIVcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:32:07 -0400
Date: Thu, 9 Sep 2010 23:31:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] posix clocks: introduce a syscall for clock
 tuning.
In-Reply-To: <1284066084.2762.172.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1009092327300.2477@localhost6.localdomain6>
References: <cover.1283504065.git.richard.cochran@omicron.at>  <7f4815cdfcf5bc49df4bdd09d59a4f56ca2598f5.1283504065.git.richard.cochran@omicron.at>  <alpine.LFD.2.00.1009091159260.2477@localhost6.localdomain6>
 <1284066084.2762.172.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, john stultz wrote:
> On Thu, 2010-09-09 at 12:49 +0200, Thomas Gleixner wrote:
> > But what I see is an approach which tries to implement disconnected
> > special purpose clocks which have the ability to be adjusted
> > independently. What's the purpose of this ? Why can't we just use the
> > existing clocks and make PTP work on them ?
> 
> So this too was my initial gut response. It seems ridiculous to expose
> two clock_ids (CLOCK_REALTIME and CLOCK_PTP)that conceptually represent
> the same thing (ie: number of seconds,nanoseconds since 1970).
> 
> It doesn't help that one of the use cases that Richard suggests is "for
> example in an embedded control application. The userland software can
> simply ignore the wrong system time." 
> 
> As someone who's spent a *lot* of time trying to fix the "wrong system
> time" these use cases reek of work-around solutions instead of properly
> fixing whatever keeps the system time from being accurately sycned.
> 
> However, as I've worked on understanding the issue, I realize that there
> is some validity to needing to expose more then one hardware clock the
> conceptually is the same as CLOCK_REALTIME. And that most of my gut
> reaction to this was me being a bit oversensitive. :)

Yup. It still scares me that we might end up with a dozen different
notions of ONE second elapsed on the same machine :)

> However, since there may be multiple PTP clocks or audio clocks or
> whatever, allocating static clockids for each type isn't quite useful,

Yeah, I corrected myself on that one, but I really want to see some
confinement into well defined clock classes rather than the "hooray
here is my clock of the day" approach.

Thanks,

	tglx
