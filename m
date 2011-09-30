Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1I3EO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:14:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43470 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1I3EO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:14:28 -0400
Date: Thu, 29 Sep 2011 21:14:24 -0700
From: Tejun Heo <htejun@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
Message-ID: <20110930041424.GH10425@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
 <20110930034815.GF10425@mtj.dyndns.org>
 <1317355529.4588.45.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317355529.4588.45.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 30, 2011 at 12:05:29AM -0400, Steven Rostedt wrote:
> > Simply removing it would allow breaking workqueue from userland by
> > manipulating affinity.  How about testing PF_WQ_WORKER in
> > set_cpus_allowed_ptr() (and maybe cpuset, I'm not sure)?
> 
> Do you realize that these threads migrate? If you didn't, it just proves
> that you shouldn't touch it.

It's rather complicated due to the way workqueues have been used.  You
can't tell whether a work really needs to be pinned to one cpu for
correctness until actual cpu hotplug time as wq users are expected to
flush such work items from hotplug notifiers, so wq workers should be
pinned on the respective cpus while the cpus are up but also need to
step aside once unplug notifiers are finished.

So, we had "don't diddle with my affinity" flag and you want to change
it, which is fine given good enough justification.  Let's talk about
this on the other reply.

Thank you.

-- 
tejun
