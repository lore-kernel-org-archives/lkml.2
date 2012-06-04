Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab2FDQdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:33:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59558 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2FDQdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:33:42 -0400
Message-ID: <1338827607.28282.99.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 18:33:27 +0200
In-Reply-To: <4FCCD6B7.4030703@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	    <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	   <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
	  <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
	 <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 08:39 -0700, Arjan van de Ven wrote:

> hmm I think you're missing the whole point.

Probably.. as I've still no clue what you're wanting to do.

> > I'm just not buying load actually matters or works, if there's lots of
> > idle time load history should be low, if there's not a lot of idle time,
> > you're busy (per definition) and again load isn't important.
> 
> if there is a lot of idle, load can be low or high; load is more than
> just cpu usage. it includes waiting for resources and mutexes etc.

It very much does not. The thing its using: this_cpu_load() returns
rq->cpu_load[0], does not include blocked tasks of any kind.

> if load is low, you are idle, sure (in that direction it works). If load
> is low, the heuristic that is used here will not hinder a deep C state
> choice.
> 
> if there is not a lot of idle time, sure, load is high.

False, you can have 0 idle time and still have low load.

>  but because idle
> time tends to be bursty, we can still be idle for, say, a millisecond
> every 10 milliseconds. In this scenario, the load average is used to
> ensure that the 200 usecond cost of exiting idle is acceptable.

So what you're saying is that if you have 1ms idle in 10ms, it might not
be a continuous 1ms. And you're using load as a measure of how many
fragments it comes apart in?

That's not making sense.

> one other way of doing this would be tracking cumulative accrued latency
> as a percentage of cpu busy time... but that's also a pretty
> approximative measure.

To what purpose? I'm completely confused now, none of what you say is
making any sense.


