Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0DSOtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:49:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0DSOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:49:08 -0400
Subject: Re: [PATCH 1/5] sched: fix capacity calculations for SMT4
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <28214.1271626457@neuling.org>
References: <20100409062118.D4096CBB6C@localhost.localdomain>
	 <1271161766.4807.1280.camel@twins> <2906.1271219317@neuling.org>
	 <1271426308.1674.429.camel@laptop>  <28214.1271626457@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 16:49:03 +0200
Message-ID: <1271688543.1488.253.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 07:34 +1000, Michael Neuling wrote:
> > Are there any numbers available on how much they gain? It might be worth
> > to stick in real numbers instead of this alleged 15%.
> 
> I get some gain numbers but obviously the workloads makes a huge
> difference.  From a scheduler perspective, I assume an
> average/representative gain is best rather than an optimistic or
> pessimistic one?

Yeah, average would be best.

> We'll have different gains for SMT2 and SMT4, so we could change the
> gain dynamically based on which SMT mode we are in.  Does that seem like
> something we should add as an arch hook?  

That's the sort of thing you can use arch_scale_smt_power() for. But be
weary to not fall into the same trap I did with x86, where I confused
actual gain with capacity (When idle the actual gain is 0, but the
capacity is not).




