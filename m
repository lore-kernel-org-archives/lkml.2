Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab2FDP0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:26:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53330 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2FDP0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:26:21 -0400
Message-ID: <1338823568.28282.79.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 17:26:08 +0200
In-Reply-To: <4FCCD0CD.8080700@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	   <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	  <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
	 <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 08:14 -0700, Arjan van de Ven wrote:
> On 6/4/2012 8:08 AM, Peter Zijlstra wrote:
> > On Mon, 2012-06-04 at 06:48 -0700, Arjan van de Ven wrote:
> >> it's not about busy, it's about performance sensitive.
> >> it's not a super nice proxy, no argument, but it's one of the few long
> >> term ones we have.
> >>
> > I'm still not seeing how it makes any sense at all. Is there an actual
> > workload here this matters?
> 
> yes there are, mostly server ones.

OK, so pick one that cares, and try creating a heuristic based on wakeup
history or whatever.

> the problem isn't an individual idle, it's that the 100us-200us
> latencies add up if you go in and out repeatedly, when the system is in
> a situation where it is sensitive to performance (which is not an
> instant thing, this is a "over the long run we're busy" thing)...
> ... they become a real factor.

Right, but since you're inflating idle time, the work will be displaced
and will complete later. This should result in your idle time est
shrinking.

I'm just not buying load actually matters or works, if there's lots of
idle time load history should be low, if there's not a lot of idle time,
you're busy (per definition) and again load isn't important.


