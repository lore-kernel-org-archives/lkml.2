Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0ETVXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:23:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:43332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0ETVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:23:16 -0400
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, axboe@kernel.dk, linux-kernel@vger.kernel.org
In-Reply-To: <1274389786.1674.1653.camel@laptop>
References: <20100520204810.GA19188@think>
	 <1274389786.1674.1653.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 23:23:12 +0200
Message-ID: <1274390592.1674.1656.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 23:09 +0200, Peter Zijlstra wrote:

> int try_to_wake_up(struct task *p, unsigned int mask, wake_flags)
> {
>   int state = atomic_read(&p->state);
> 
>   do {
>     if (!(state & mask))
>       return 0;
> 
>     state = atomic_cmpxchg(&p->state, state, TASK_WAKING);
>   } while (state != TASK_WAKING);

    cpu = select_task_rq()

and then somehow see we get set_task_cpu() done without races :-)

>   /* do this pending queue + ipi thing */
> 
>   return 1;
> }


