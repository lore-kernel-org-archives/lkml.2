Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab1FWIh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 04:37:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39153 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab1FWIh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 04:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oHGlfrioeyYZC29FNcQKvw5+LW/Zz+o47v7svFjqON3LTUyT1It8pfBU1tj5zZX49h
         ohzYZFxGdJIDw9Yvk3pzqDdqqIaG8cL6hh3yoyuyNIyT1D6zGvte7qOny7B8bvav757I
         afxoLFly4U8soUs4NeOFkndyusGIZiwC5K+2Q=
Date: Thu, 23 Jun 2011 10:37:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20110623083722.GF30101@htj.dyndns.org>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622174919.135236139@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

The hooking place doesn't have anything to do with rq->lock.  The
problem with Peter's patch was preemption, not the lock.

> There is also no harm from updating nr_running when the task returns
> from scheduling instead of accounting it in the wakeup code.

Well, not exactly.  If CPU is being thrashed, we don't want to try to
fire up new workers or calling in rescuers.  If nr_running is bumped
up from ttwu(), a woken up but not yet running worker already counts
as running.  With the suggested change, when we hit such heavy CPU
thrashing, workqueue code will add things on top of it.

Thanks.

-- 
tejun
