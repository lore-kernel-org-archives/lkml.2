Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2AZCVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 21:21:37 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52623 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab2AZCVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 21:21:35 -0500
Date: Thu, 26 Jan 2012 03:21:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
Message-ID: <20120126022128.GG20878@somewhere>
References: <1327026020-32376-1-git-send-email-asharma@fb.com>
 <1327318449.2446.5.camel@twins>
 <4F1DA9D0.6090208@fb.com>
 <1327352631.2446.22.camel@twins>
 <4F1DE6FE.4000603@fb.com>
 <1327415255.2614.33.camel@laptop>
 <4F1F26CC.4040109@fb.com>
 <20120125092008.GB20878@somewhere>
 <4F205D1D.1020304@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F205D1D.1020304@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:50:53AM -0800, Arun Sharma wrote:
> On 1/25/12 1:20 AM, Frederic Weisbecker wrote:
> 
> >>>I'm tempted to revert 1ac9bc69 for now, userspace will simply have to
> >>>correlate trace_sched_switch() and trace_sched_stat_{sleep,blocked}(),
> >>>which shouldn't be too hard.
> >>
> >>We tried it and it didn't work very well. Especially when used with
> >>perf record -g. There are too many uninteresting
> >>trace_sched_switch() events.
> >
> >You mean context switches happening when the prev task doesn't need
> >to block or so? As it happens with preemption for example?
> >
> >In this case you can use filters to drop context switches for
> >which the prev state is not S or D.
> 
> We had these filters and still couldn't keep up:
> 
> # perf record -agP -e sched:sched_switch --filter "prev_state == 1
> || prev_state == 2" -e  sched:sched_stat_sleep -- sleep 3
> [ perf record: Woken up 107 times to write data ]
> [ perf record: Captured and wrote 32.629 MB perf.data (~1425585 samples) ]
> Warning:
> Processed 104066 events and lost 4 chunks!
> 
> Check IO/CPU overload!

Have you tried to tweak the -m options to increase the size of the buffer?

> 
>  -Arun
