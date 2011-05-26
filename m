Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1EZOzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:55:44 -0400
Received: from service87.mimecast.com ([94.185.240.25]:54574 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753168Ab1EZOzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:55:43 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1306412511.1200.90.camel@twins>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins>  <1306412511.1200.90.camel@twins>
Organization: ARM Ltd
Date: Thu, 26 May 2011 15:56:21 +0100
Message-ID: <1306421781.27474.224.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 26 May 2011 14:55:46.0772 (UTC) FILETIME=[FEAD1140:01CC1BB4]
X-MC-Unique: 111052615553604001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 14:21 +0200, Peter Zijlstra wrote:
> On Thu, 2011-05-26 at 13:32 +0200, Peter Zijlstra wrote:
> > 
> > The bad news is of course that I've got a little more head-scratching to
> > do, will keep you informed. 
> 
> OK, that wasn't too hard.. (/me crosses fingers and prays Marc doesn't
> find more funnies ;-).
> 
> Does the below cure all woes?

So far so good. The box just went through it's two first iterations of
kernel building without a sweat, carried on, and still feels snappy
enough.

Thanks for having fixed that quickly!

> ---
> Subject: sched: Fix ttwu() for __ARCH_WANT_INTERRUPTS_ON_CTXSW
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu May 26 14:21:33 CEST 2011
> 
> Marc reported that e4a52bcb9 (sched: Remove rq->lock from the first
> half of ttwu()) broke his ARM-SMP machine. Now ARM is one of the few
> __ARCH_WANT_INTERRUPTS_ON_CTXSW users, so that exception in the ttwu()
> code was suspect.
> 
> Yong found that the interrupt could hit hits after context_switch() changes
> current but before it clears p->on_cpu, if that interrupt were to
> attempt a wake-up of p we would indeed find ourselves spinning in IRQ
> context.
> 
> Sort this by reverting to the old behaviour for this situation and
> perform a full remote wake-up.
> 
> Cc: Frank Rowand <frank.rowand@am.sony.com>
> Cc: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Reported-by: Marc Zyngier <Marc.Zyngier@arm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Tested-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Reality is an implementation detail.


