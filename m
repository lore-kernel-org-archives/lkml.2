Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0CQBVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 21:21:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:8758 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab0CQBVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 21:21:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,654,1262592000"; 
   d="scan'208";a="255470219"
Subject: Re: [tip:perf/x86] perf, x86: Implement initial P4 PMU driver
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "acme@redhat.com" <acme@redhat.com>,
       "eranian@google.com" <eranian@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20100316162314.GG5206@lenovo>
References: <20100311165439.GB5129@lenovo>
	 <tip-a072738e04f0eb26370e39ec679e9a0d65e49aea@git.kernel.org>
	 <20100316160733.GR1585@erda.amd.com>  <20100316162314.GG5206@lenovo>
Content-Type: text/plain
Date: Wed, 17 Mar 2010 09:05:02 +0800
Message-Id: <1268787902.13901.36.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 00:23 +0800, Cyrill Gorcunov wrote:
> On Tue, Mar 16, 2010 at 05:07:33PM +0100, Robert Richter wrote:
> [...]
> > --
> > 
> > From: Robert Richter <robert.richter@amd.com>
> > Date: Tue, 16 Mar 2010 16:38:19 +0100
> > Subject: [PATCH] perf, x86: reporting error code that returns from x86_pmu.hw_config()
> > 
> > If x86_pmu.hw_config() fails a fixed error code (-EOPNOTSUPP) is
> > return even if a different error was reported. This patch fixes this.
> > 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 4e2480f..8982d92 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -467,8 +467,9 @@ static int __hw_perf_event_init(struct perf_event *event)
> >  	hwc->last_tag = ~0ULL;
> >  
> >  	/* Processor specifics */
> > -	if (x86_pmu.hw_config(attr, hwc))
> > -		return -EOPNOTSUPP;
> > +	err = x86_pmu.hw_config(attr, hwc);
> > +	if (err)
> > +		return err;
> >  
> >  	if (!hwc->sample_period) {
> >  		hwc->sample_period = x86_pmu.max_period;
> > -- 
> > 1.7.0
> >
> 
> Though at moment all hw_config callees return 0, it's better
> to be ready if one day we may start returning some particular
> errors. Looks good to me. Objections?

Looks good.

Lin Ming

> 
> 	-- Cyrill

