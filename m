Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2AZC1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:27:40 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:33797 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab2AZC1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:27:40 -0500
Date: Thu, 26 Jan 2012 03:27:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
Message-ID: <20120126022732.GH20878@somewhere>
References: <1327318449.2446.5.camel@twins>
 <4F1DA9D0.6090208@fb.com>
 <1327352631.2446.22.camel@twins>
 <4F1DE6FE.4000603@fb.com>
 <1327415255.2614.33.camel@laptop>
 <4F1F26CC.4040109@fb.com>
 <20120125092008.GB20878@somewhere>
 <4F205D1D.1020304@fb.com>
 <1327522558.22710.47.camel@gandalf.stny.rr.com>
 <4F20823A.6010808@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F20823A.6010808@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 02:29:14PM -0800, Arun Sharma wrote:
> On 1/25/12 12:15 PM, Steven Rostedt wrote:
> 
> >trace-cmd record -e sched_switch -f 'prev_state == 1 || prev_state == 2' -e sched_stat_sleep sleep 3
> >
> >I'm not sure the filter is even needed, and it should still keep up
> >fine.
> 
> Better - I didn't see any overruns with trace-cmd.
> 
> Even if we resolve the sampling rate related problems, there is the
> issue of: can we trust that a sampled sched_switch event and a
> sampled sched_stat_sleep event actually match each other?

Well, a sched_stat_sleep event should match the sched_switch with
prev as the last targeted task.

Or am I missing something?

> 
> There is consensus here that touching an extra cacheline in the
> context switch path is a good trade-off given the usefulness of
> sleep profiling in troubleshooting latency problems.
> 
> Since it may not be a good trade-off for everyone, we just need to
> figure out where to store some per-task state. To recap two
> potential paths to investigate:
> 
> * store sleep_start someplace else that no one other than
> sched_stat_sleeptime() knows about.
> 
> * store state in task struct that remembers whether the last context
> switch was a preemption or not.
> 
>  -Arun
