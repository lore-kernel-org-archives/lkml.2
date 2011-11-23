Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1KWRGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:06:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40278 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1KWRGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:06:43 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=c8QOUBVbWuQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=JHdT3DEE1iB2qg4j26gA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20111123160653.GB25780@google.com>
References: <20111123014603.GA19630@google.com>
	 <1322061407.20742.51.camel@frodo>  <20111123160653.GB25780@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 12:06:40 -0500
Message-ID: <1322068000.20742.61.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 08:06 -0800, Tejun Heo wrote:

> So, synchronized_sched() being called after isn't relevant.  We want
> smp_wmb() between data structure initialization and assignment of the
> new pointer.

Ah, you're saying that we need to guarantee that the allocated filter is
seen before we update the call->filter to point to it. OK, fair enough,
this does look like a bug fix.

Is it big enough to be considered for stable?

-- Steve


