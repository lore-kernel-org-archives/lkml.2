Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0FYTtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:49:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab0FYTtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:49:23 -0400
Subject: Re: [RFC][PATCH] irq_work -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>, davem <davem@davemloft.net>,
       paulus <paulus@samba.org>
In-Reply-To: <1277494784.1875.989.camel@laptop>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop> <1277490625.1875.986.camel@laptop>
	 <20100625193031.GD13421@basil.fritz.box> <1277494784.1875.989.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 21:49:13 +0200
Message-ID: <1277495353.1875.991.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 21:39 +0200, Peter Zijlstra wrote:
> On Fri, 2010-06-25 at 21:30 +0200, Andi Kleen wrote:
> > 
> > I'm not sure what all the logic for entry enqueued by someone
> > else is good for? Is that for the case you don't have enough
> > entries preallocated and you share them with someone else?
> > 
> > Normally if the sharing is per cpu that would be difficult 
> > to recover from because if it's due to a nest situation (for example)
> > you would deadlock.
> > 
> > For me it would seem simpler to simply not share.
> 
> perf has two different reasons to for the callback, what I do is set the
> state and enqueue, if its already enqueued the pending callback will
> handle both.
> 
> Its cheaper than having two callback structures per event.
> 
> We can expose the claim/enqueue thing separately so that users can
> choose.

Also, its possible the PMI hits again before the IRQ callback has a
chance to happen.


