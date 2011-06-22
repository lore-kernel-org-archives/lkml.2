Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab1FVSng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:43:36 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38639
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758623Ab1FVSne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:43:34 -0400
Date: Wed, 22 Jun 2011 14:43:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] sched: Separate the scheduler entry for preemption
Message-ID: <20110622184328.GA6475@infradead.org>
References: <20110622174659.496793734@linutronix.de>
 <20110622174918.813258321@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622174918.813258321@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 05:52:13PM -0000, Thomas Gleixner wrote:
> Block-IO and workqueues call into notifier functions from the
> scheduler core code with interrupts and preemption disabled. These
> calls should be made before entering the scheduler core.
> 
> To simplify this, separate the scheduler core code into
> __schedule(). __schedule() is directly called from the places which
> set PREEMPT_ACTIVE and from schedule(). This allows us to add the work
> checks into schedule(), so they are only called when a task voluntary
> goes to sleep.

I don't think that works.  We'll need to flush the block requests even
for an involuntary schedule.

