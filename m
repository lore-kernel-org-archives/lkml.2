Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab1I3EIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:08:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47679 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1I3EIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:08:47 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=YzuRFytPCtMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=kUN8FQy3kzNJ7AmodpcA:9 a=XR44KWIyqb5cbutHLYkA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 30 Sep 2011 00:08:45 -0400
In-Reply-To: <20110930035501.GG10425@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930035501.GG10425@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317355726.4588.48.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:55 -0700, Tejun Heo wrote:
> On Tue, Sep 27, 2011 at 05:17:34PM -0400, Steven Rostedt wrote:
> > For convenience and optimization, we are going to use the task's flag
> > PF_THREAD_BOUND as a way to know if a task is bound to a CPU or not. As
> > that is what the flag means.
> 
> And I'm not sure this is a very good idea.  Until now, PF_THREAD_BOUND
> meant "this task is explicitly bound to the current affinity (whatever
> it is) and thus it shouldn't be manipulated by third party".

That's exactly what we want it to mean. Not manipulated by workqueue or
anyone else. We don't plan on setting this flag if a task just happens
to have only one CPU in its affinity. We only set this flag if the task
is bounded to a CPU for good. When we see this flag set, we can therefor
assume that it will not migrate!


>   The
> suggested change makes the flag much less orthogonal and useful.  How
> much of convenience and optimization are we talking about?
> 

Enough to not have to manually pin the task to the cpu at every lock.

-- Steve


