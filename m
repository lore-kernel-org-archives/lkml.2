Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab1FVHBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 03:01:45 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:49952 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1FVHBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 03:01:44 -0400
X-ASG-Debug-ID: 1308726103-03d6a510a98cb60001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E019353.6030902@fusionio.com>
Date: Wed, 22 Jun 2011 09:01:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 1/3] sched, block: Move unplug
References: <20110621233444.094372367@chello.nl> <20110621233648.806475812@chello.nl>
X-ASG-Orig-Subj: Re: [RFC][PATCH 1/3] sched, block: Move unplug
In-Reply-To: <20110621233648.806475812@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1308726103
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66771
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-22 01:34, Peter Zijlstra wrote:
> Thomas found that we're doing a horrendous amount of work in that scheduler
> unplug hook while having preempt and IRQs disabled.
> 
> Move it to the head of schedule() where both preemption and IRQs are enabled
> such that we don't get these silly long IRQ/preempt disable times.
> 
> This allows us to remove a lot of special magic in the unplug path,
> simplifying that code as a bonus.

The major change here is moving the queue running inline, instead of
punting to a thread. The worry is/was that we risk blowing the stack if
something ends up blocking inadvertently further down the call path.
Since it's the unlikely way to unplug, a bit of latency was acceptable
to prevent this problem.

I'm curious why you made that change? It seems orthogonal to the change
you are actually describing in the commit message.

-- 
Jens Axboe

