Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1KWRdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:33:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63350 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1KWRdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:33:19 -0500
Date: Wed, 23 Nov 2011 09:33:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
Message-ID: <20111123173313.GB29639@google.com>
References: <20111123014603.GA19630@google.com>
 <1322061407.20742.51.camel@frodo>
 <20111123160653.GB25780@google.com>
 <1322068000.20742.61.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322068000.20742.61.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

On Wed, Nov 23, 2011 at 12:06:40PM -0500, Steven Rostedt wrote:
> > So, synchronized_sched() being called after isn't relevant.  We want
> > smp_wmb() between data structure initialization and assignment of the
> > new pointer.
> 
> Ah, you're saying that we need to guarantee that the allocated filter is
> seen before we update the call->filter to point to it. OK, fair enough,
> this does look like a bug fix.
> 
> Is it big enough to be considered for stable?

It's unlikely to happen for x86 or arm and that probably is the
biggest reason there hasn't already been a bug report.  It isn't very
urgent but at the same time the change is almost trivial, so marking
it for stable is a pretty safe bet.  I lean toward marking it for
stable but the leaning isn't too strong. :)

Thanks.

-- 
tejun
