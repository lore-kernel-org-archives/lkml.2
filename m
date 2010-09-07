Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0IGNDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:03:04 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:46592 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333Ab0IGNC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:02:58 -0400
Date: Tue, 7 Sep 2010 23:02:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100907130243.GQ705@dastard>
References: <20100907072954.GM705@dastard>
 <4C86003B.6090706@kernel.org>
 <20100907100108.GN705@dastard>
 <4C861582.6080102@kernel.org>
 <4C862F8E.7030507@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C862F8E.7030507@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 02:26:54PM +0200, Tejun Heo wrote:
> On 09/07/2010 12:35 PM, Tejun Heo wrote:
> > Can you please help me a bit more?  Are you saying the following?
> > 
> > Work w0 starts execution on wq0.  w0 tries locking but fails.  Does
> > delay(1) and requeues itself on wq0 hoping another work w1 would be
> > queued on wq0 which will release the lock.  The requeueing should make
> > w0 queued and executed after w1, but instead w1 never gets executed
> > while w0 hogs the CPU constantly by re-executing itself.  Also, how
> > does delay(1) help with chewing up CPU?  Are you talking about
> > avoiding constant lock/unlock ops starving other lockers?  In such
> > case, wouldn't cpu_relax() make more sense?
> 
> Ooh, almost forgot.  There was nr_active underflow bug in workqueue
> code which could lead to malfunctioning max_active regulation and
> problems during queue freezing, so you could be hitting that too.  I
> sent out pull request some time ago but hasn't been pulled into
> mainline yet.  Can you please pull from the following branch and add
> WQ_HIGHPRI as discussed before and see whether the problem is still
> reproducible?

I'm currently running with the WQ_HIGHPRI flag. I only change one
thing at a time so I can tell what caused the change in behaviour...

> And if the problem is reproducible, can you please
> trigger sysrq thread dump and attach it?

Well, most of the time the system is 100% unresponsive when the
livelock occurs, so I'll be lucky to get anything at all....

>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

I'll try that next if the probelm still persists.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
