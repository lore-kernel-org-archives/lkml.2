Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab0FRIlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:41:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41975 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab0FRIlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:41:15 -0400
Subject: Re: [RFC][PATCH 3/8] perf: register pmu implementations
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100617233113.GA2302@brick.ozlabs.ibm.com>
References: <20100616160027.590430763@chello.nl>
	 <20100616160238.241599593@chello.nl>
	 <20100617233113.GA2302@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 10:40:46 +0200
Message-ID: <1276850446.1975.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 09:31 +1000, Paul Mackerras wrote:
> 
> > @@ -1011,7 +1001,7 @@ static int hw_perf_cache_event(u64 confi
> >       return 0;
> >  }
> >  
> > -struct pmu *hw_perf_event_init(struct perf_event *event)
> > +static int power_pmu_event_init(struct perf_event *event)
> 
> How does power_pmu_event_init ever get called now?  I don't see any
> other references to it in the patch.  Should struct pmu have a
> reference to it? 

Uhm yeah.. looks like that went pear-shaped. Fixed it.

---
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -1125,6 +1125,7 @@ static int power_pmu_event_init(struct p
 }
 
 struct pmu power_pmu = {
+	.event_init	= power_pmu_event_init,
 	.enable		= power_pmu_enable,
 	.disable	= power_pmu_disable,
 	.read		= power_pmu_read,

