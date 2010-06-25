Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0FYTrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:47:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab0FYTrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:47:15 -0400
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
Date: Fri, 25 Jun 2010 21:47:03 +0200
Message-ID: <1277495223.1875.990.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 21:30 +0200, Andi Kleen wrote:
> > +             entry->next = next_flags(NULL, IRQ_WORK_BUSY);
> > +             entry->func(entry);
> 
> Needs compiler memory barrier here I think.
> 
> > +             /*
> > +              * Clear the BUSY bit and return to the free state if
> > +              * no-one else claimed it meanwhile.
> > +              */
> > +             cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
> > +     } 

Both the (indirect) function call and the cmpxchg imply a compiler
barrier.
