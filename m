Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0JDJVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:21:18 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:45287 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754088Ab0JDJVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:21:16 -0400
Date: Mon, 4 Oct 2010 20:21:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Yang Ruirui <ruirui.r.yang@tieto.com>,
        Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
Subject: Re: -mm: xfs lockdep warning
Message-ID: <20101004092107.GJ4681@dastard>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
 <20100917005227.GJ24409@dastard>
 <20100920191355.GA28443@infradead.org>
 <AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
 <4CA997DF.5030008@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA997DF.5030008@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 11:01:19AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 09/25/2010 03:08 PM, Torsten Kaiser wrote:
> > [adding Tejun Heo, because I'm partly blaming his workqueues]
> 
> :-) Sorry about the delay.  I was away the last week.
> 
> > After that I enabled lockdep and retried the same update: This time no
> > hang, only the same lockdep report that Yang Ruirui had.
> > 
> > So I'm currently at a loss how I should continue from here. The XFS
> > false positive drowns any other lockdep problems, but XFS had some
> > hang problems with the new workqueues. (Personally I had no other hang
> > with earlier 2.6.36-rcs)

What XFS hang problem? I've seen temporary livelocks from the new
workqueue code, but thay have been fixed. I haven't come across any
deadlocks or hangs. Do you have a pointer to a bug report in case my
memory is failing me?

> If workqueue lockdep annotations are triggering spuriously, just nuke
> all lockdep annotations in workqueue.c.  Currently the annotations are
> the same as before and trigger even when an actual deadlock won't
> happen anymore around flushes (but then again all the current users
> should be operating under the same constraints as before).  I'm
> looking into how to improve the lockdep annotations but in the end it
> might be best to leave it as it is.  I'll try to analyze the warnings.

It looks like there's been some discussion that has been private so
I'm clueless as to the context being discussed here.  Can someone
fill me in on whatever is going on?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
