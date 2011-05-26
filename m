Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1EZRHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab1EZRHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:07:00 -0400
Date: Thu, 26 May 2011 19:04:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
	locks up on ARM
Message-ID: <20110526170422.GA18413@redhat.com>
References: <1306343335.21578.65.camel@twins> <1306358128.21578.107.camel@twins> <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com> <1306405979.1200.63.camel@twins> <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com> <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins> <20110526154508.GA13788@redhat.com> <1306425584.2497.81.camel@laptop> <1306426148.2497.83.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306426148.2497.83.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Peter Zijlstra wrote:
>
> @@ -2636,7 +2636,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  		 * to spin on ->on_cpu if p is current, since that would
>  		 * deadlock.
>  		 */
> -		if (p == current) {
> +		if (cpu == smp_processor_id()) {
> +			p->sched_contributes_to_load = 0;
>  			ttwu_queue(p, cpu);

Btw. I do not pretend I really understand se->vruntime, but in this
case we are doing enqueue_task() without ->task_waking(), however we
pass ENQUEUE_WAKING. Is it correct?

Oleg.

