Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab1EZMi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:38:28 -0400
Received: from canuck.infradead.org ([134.117.69.58]:41458 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab1EZMi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:38:27 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110526123137.GG24876@n2100.arm.linux.org.uk>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	 <1306272750.2497.79.camel@laptop> <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
	 <20110526122623.GA11875@elte.hu>
	 <20110526123137.GG24876@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 May 2011 14:37:34 +0200
Message-ID: <1306413454.1200.92.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 13:31 +0100, Russell King - ARM Linux wrote:
> On Thu, May 26, 2011 at 02:26:23PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Sort this by reverting to the old behaviour for this situation and 
> > > perform a full remote wake-up.
> > 
> > Btw., ARM should consider switching most of its subarchitectures to 
> > !__ARCH_WANT_INTERRUPTS_ON_CTXSW - enabling irqs during context 
> > switches is silly and now expensive as well.
> 
> Not going to happen.  The reason we do it is because most of the CPUs
> have to (slowly) flush their caches during switch_mm(), and to have
> IRQs off over the cache flush means that we lose IRQs.
> 
> So it's not silly at all, bit a technical requirement imposed by the
> cache architecture.
> 
> If it's become expensive through development, it suggests that the
> development did not take account of the issues we have on ARM.

Its not more expensive than it was before this patch series, and the
case in question is relatively rare (guesstimate, lacking measurements)
so ARM should benefit from most of the optimization provided.


