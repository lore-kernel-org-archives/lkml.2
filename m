Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab0EYBol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:44:41 -0400
Received: from ozlabs.org ([203.10.76.45]:56588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682Ab0EYBok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:44:40 -0400
Date: Tue, 25 May 2010 11:43:23 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/4] perf: Add exclude_task perf event attribute
Message-ID: <20100525014323.GC30395@drongo>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
 <1274450715-23955-3-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274450715-23955-3-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 04:05:13PM +0200, Frederic Weisbecker wrote:

> Excluding is useful when you want to trace only hard and softirqs.
> 
> For this we use a new generic perf_exclude_event() (the previous
> one beeing turned into perf_exclude_swevent) to which you can pass
> the preemption offset to which your events trigger.
> 
> Computing preempt_count() - offset gives us the preempt_count() of
> the context that the event has interrupted, on top of which we
> can filter the non-irq contexts.

How does this work for hardware events when we are sampling and
getting an interrupt every N events?  It seems like the hardware is
still counting all events and interrupting every N events, but we are
only recording a sample if the interrupt occurred in the context we
want.  In other words the context of the Nth event is considered to be
the context for the N-1 events preceding that, which seems a pretty
poor approximation.

Also, for hardware events, if we are counting rather than sampling,
the exclude_task bit will have no effect.  So perhaps in that case the
perf_event_open should fail rather than appear to succeed but give
wrong data.

Paul.
