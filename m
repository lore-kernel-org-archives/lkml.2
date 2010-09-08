Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab0IHI23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:28:29 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:43915 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758481Ab0IHI2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:28:23 -0400
Date: Wed, 8 Sep 2010 18:28:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100908082819.GV705@dastard>
References: <20100907072954.GM705@dastard>
 <4C86003B.6090706@kernel.org>
 <20100907100108.GN705@dastard>
 <4C861582.6080102@kernel.org>
 <20100907124850.GP705@dastard>
 <4C865CC4.9070701@kernel.org>
 <20100908073428.GR705@dastard>
 <4C87474B.3050405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C87474B.3050405@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:20:27AM +0200, Tejun Heo wrote:
> On 09/08/2010 09:34 AM, Dave Chinner wrote:
> >> Probably I have overloaded the term 'concurrency' too much.  In this
> >> case, I meant the number of workers assigned to work items of the wq.
> >> If you fire off N work items which sleep at the same time, cmwq will
> >> eventually try to create N workers as each previous worker goes to
> >> sleep so that the CPU doesn't sit idle while there are work items to
> >> process as long as N < @wq->nr->active.
> > 
> > Ok, so if I queue N items on a single CPU when max_active == N, they
> > get spread across N worker threads on different CPUs? 
> 
> They may if necessary to keep the workqueue progressing.

Ok, so the normal case is that they will all be processed local to the
CPU they were queued on, like the old workqueue code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
