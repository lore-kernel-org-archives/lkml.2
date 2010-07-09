Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0GIKb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:31:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:34387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab0GIKbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:31:25 -0400
Subject: Re: [RFC][PATCH 10/13] perf: Per PMU disable
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100709101703.GR7771@brick.ozlabs.ibm.com>
References: <20100709082117.631541128@chello.nl>
	 <20100709083248.156796575@chello.nl>
	 <20100709101703.GR7771@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 12:30:58 +0200
Message-ID: <1278671458.1900.193.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 20:17 +1000, Paul Mackerras wrote:
> On Fri, Jul 09, 2010 at 10:21:27AM +0200, Peter Zijlstra wrote:
> 
> > -void hw_perf_disable(void)
> > +static void powerpc_pmu_pmu_disable(struct pmu *pmu)
> 
> > -void hw_perf_enable(void)
> > +static void powerpc_pmu_pmu_enable(struct pmu *pmu)
> 
> >  struct pmu power_pmu = {
> > -	.event_init	= power_pmu_event_init,
> > +	.pmu_enable	= power_pmu_pmu_enable,
> > +	.pmu_disable	= power_pmu_pmu_disable,
> > +	.event_init	= pmwer_pmu_event_init,
> 
> Doh!  Think you posted the old version of the patch again...

*sigh*
