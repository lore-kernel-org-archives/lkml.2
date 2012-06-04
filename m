Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab2FDNph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:45:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57017 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab2FDNpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:45:35 -0400
Message-ID: <1338817519.28282.54.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 15:45:19 +0200
In-Reply-To: <4FCCB486.4040905@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	 <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 06:13 -0700, Arjan van de Ven wrote:
> On 6/4/2012 3:32 AM, Peter Zijlstra wrote:
> > On Mon, 2012-06-04 at 14:24 +0400, Vladimir Davydov wrote:
> >> rq->cpuload strongly depends on cgroup hierarchy. For example, if hundreds of
> >> tasks are running inside cpu:/test cgroup, the sum of cpuload over all cpus
> >> won't exceed 1024 (by default). That makes the cpuidle menu governor take wrong
> >> decisions, which can negatively affect overall performance.
> >>
> >> To cope this, use nr_running last seen in __update_cpu_load() instead of
> >> cpuload for calculating performance multiplier.
> > 
> > What is cpuidle trying to do?
> 
> what it is doing is trying to use "cpuload" as proxy for performance
> sensitivity. The higher the load, the longer the idle period (predicted)
> needs to be, for cpuidle to be willing to tolerate the latency of deeper
> C states.

Well, both are complete crap of course.. load has no relation to busy
what so ever anyway.

But what you're saying is that its trying to correlate latency with
load, higher loaded systems should receive less latency spikes. Why does
this make sense at all?

Or are we simply trying to guestimate the idle period and got confused?
Neither nr_running nor cpu_load have anything to do with how busy we
are.
