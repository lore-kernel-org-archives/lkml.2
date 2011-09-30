Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1I3E27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:28:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54443 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1I3E26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:28:58 -0400
Date: Thu, 29 Sep 2011 21:28:55 -0700
From: Tejun Heo <htejun@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
Message-ID: <20110930042855.GI10425@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
 <20110930035501.GG10425@mtj.dyndns.org>
 <1317355726.4588.48.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317355726.4588.48.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 30, 2011 at 12:08:45AM -0400, Steven Rostedt wrote:
> On Thu, 2011-09-29 at 20:55 -0700, Tejun Heo wrote:
> > On Tue, Sep 27, 2011 at 05:17:34PM -0400, Steven Rostedt wrote:
> > > For convenience and optimization, we are going to use the task's flag
> > > PF_THREAD_BOUND as a way to know if a task is bound to a CPU or not. As
> > > that is what the flag means.
> > 
> > And I'm not sure this is a very good idea.  Until now, PF_THREAD_BOUND
> > meant "this task is explicitly bound to the current affinity (whatever
> > it is) and thus it shouldn't be manipulated by third party".
> 
> That's exactly what we want it to mean. Not manipulated by workqueue or
> anyone else.

Umm... those are wq workers and wq is third party?  I'm sorry that you
wasted your time but let's please drop the bickering over the
interpretation of the flag.

> We don't plan on setting this flag if a task just happens
> to have only one CPU in its affinity. We only set this flag if the task
> is bounded to a CPU for good. When we see this flag set, we can therefor
> assume that it will not migrate!

Up to now, it did NOT mean that.  It just blocked out affinity
manipulation by third party and cpuset attach.  From what you write, I
think the added assumptions are...

* The affinity should be confined to single CPU.

* Once set, the flag can't be cleared and affinity can't be changed by
  anyone.

Am I right?

> > suggested change makes the flag much less orthogonal and useful.  How
> > much of convenience and optimization are we talking about?
> 
> Enough to not have to manually pin the task to the cpu at every lock.

As I wrote before we can test PF_WQ_WORKER too where appropriate
(probably just set_cpus_allowed_ptr) and avoid using PF_THREAD_BOUND
for wq workers.  We can also add a new flag but w/ wq being the only
user, that probably is an overkill.

Thank you.

-- 
tejun
