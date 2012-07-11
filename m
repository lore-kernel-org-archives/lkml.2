Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2GKOst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:48:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64532 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab2GKOss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:48:48 -0400
Date: Wed, 11 Jul 2012 16:48:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] trace: add ability to set a target task for events (v2)
Message-ID: <20120711144840.GC17991@somewhere>
References: <1342016098-213063-1-git-send-email-avagin@openvz.org>
 <20120711143121.GA17991@somewhere>
 <1342017221.3462.159.camel@twins>
 <20120711143656.GB17991@somewhere>
 <1342017499.3462.160.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342017499.3462.160.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 04:38:19PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-07-11 at 16:36 +0200, Frederic Weisbecker wrote:
> > 
> > In this case he can just record sched wakeup as well. With sched_switch
> > + sched_wakeup, he'll unlikely lose events.
> > 
> > With sched_stat_sleep he will lose events, unless we fix this period
> > demux thing. 
> 
> But without this patch, the sched_wakeup will belong to another task, so
> if you trace task A, and B wakes you, you'll never see the wakeup.

Ah so the goal is to minimize the amount of events by only tracing task A?
Ok then. Still we need to fix these events that use __perf_count() because
wide tracing of sched_switch/wake_up still generate less events than
sched stat sleep.

I believe:

	perf record -e sched:sched_stat_sleep sleep 1

produces 1 billion events because we sleep 1 billion nanosecs. Or
something like that.
