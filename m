Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab0FYTkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:40:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab0FYTkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:40:03 -0400
Subject: Re: [RFC][PATCH] irq_work -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>, davem <davem@davemloft.net>,
       paulus <paulus@samba.org>
In-Reply-To: <20100625193031.GD13421@basil.fritz.box>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop> <1277490625.1875.986.camel@laptop>
	 <20100625193031.GD13421@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 21:39:44 +0200
Message-ID: <1277494784.1875.989.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 21:30 +0200, Andi Kleen wrote:
> 
> I'm not sure what all the logic for entry enqueued by someone
> else is good for? Is that for the case you don't have enough
> entries preallocated and you share them with someone else?
> 
> Normally if the sharing is per cpu that would be difficult 
> to recover from because if it's due to a nest situation (for example)
> you would deadlock.
> 
> For me it would seem simpler to simply not share.

perf has two different reasons to for the callback, what I do is set the
state and enqueue, if its already enqueued the pending callback will
handle both.

Its cheaper than having two callback structures per event.

We can expose the claim/enqueue thing separately so that users can
choose.
