Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0FXMC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:02:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0FXMCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:02:54 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100624115838.GG578@basil.fritz.box>
References: <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
	 <1277364727.1875.857.camel@laptop> <20100624102725.GA578@basil.fritz.box>
	 <1277375409.1875.943.camel@laptop> <20100624105254.GB578@basil.fritz.box>
	 <1277377121.1875.948.camel@laptop> <20100624110830.GC578@basil.fritz.box>
	 <1277377852.1875.950.camel@laptop> <20100624112040.GD578@basil.fritz.box>
	 <1277379731.1875.961.camel@laptop>  <20100624115838.GG578@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 14:02:48 +0200
Message-ID: <1277380968.1875.965.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:58 +0200, Andi Kleen wrote:
> On Thu, Jun 24, 2010 at 01:42:11PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-06-24 at 13:20 +0200, Andi Kleen wrote:
> > > Ok so going back to the original self-irq patchkit. Unfortunately the other
> > > reviewer hated that. How to get out of that deadlock?
> > 
> > Well, I didn't like your original patch either.
> > 
> > What's wrong with going with the patch I posted today? (aside from me
> > getting the barriers slightly wrong and not doing the arch
> > implementation).
> 
> Well it would need to work.

Look at kernel/perf_event.c:perf_pending_queue()/__perf_pending_run()

> Also I personally didn't see the point of the irq items list because
> there's no good way to dynamically allocate it in a NMI, so the window
> would be always "fixed size" anyways and you could as well just use 
> per cpu data.
> 
> That's why for simple self irq I preferred Ying's original patch.

I already told you that I have an irq_work in every perf_event structure
(its called perf_pending_entry), I cannot register an id for each
perf_event because:
  1) there's potentially more than 32 of them
  2) I'd need an id->perf_event map which is a waste of time




