Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab0FVJK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:10:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:63665 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0FVJKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,459,1272870000"; 
   d="scan'208";a="529085098"
Subject: Re: [PATCH V2 4/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C20734A.3000008@redhat.com>
References: <1277112706.2096.512.camel@ymzhang.sh.intel.com>
	 <4C20734A.3000008@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 22 Jun 2010 17:10:26 +0800
Message-Id: <1277197826.2096.713.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 10:24 +0200, Jes Sorensen wrote:
> On 06/21/10 11:31, Zhang, Yanmin wrote:
> > @@ -583,10 +584,20 @@ static void x86_pmu_disable_all(void)
> >  	}
> >  }
> >  
> > +#ifdef CONFIG_KVM_PERF
> > +static int kvm_hw_perf_enable(void);
> > +static int kvm_hw_perf_disable(void);
> > +#endif
> 
> Please put these prototypes into a header ... and create dummy stubs for
> them when CONFIG_KVM_PERF is not set.
Ok. I just didn't want to touch too much generic codes of perf.

> 
> >  void hw_perf_disable(void)
> >  {
> >  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> >  
> > +#ifdef CONFIG_KVM_PERF
> > +	if (!kvm_hw_perf_disable())
> > +		return;
> > +#endif
> 
> If you stub them out we can avoid all the ugly #ifdefs
Ok.

> 
> > @@ -810,6 +821,11 @@ void hw_perf_enable(void)
> >  	struct hw_perf_event *hwc;
> >  	int i, added = cpuc->n_added;
> >  
> > +#ifdef CONFIG_KVM_PERF
> > +	if (!kvm_hw_perf_enable())
> > +		return;
> > +#endif
> 
> and here....
Ok.

> 
> > @@ -1317,6 +1334,11 @@ void __init init_hw_perf_events(void)
> >  
> >  	pr_info("Performance Events: ");
> >  
> > +#ifdef CONFIG_KVM_PERF
> > +	if (!kvm_init_hw_perf_events())
> > +		return;
> > +#endif
> 
> and again here :)
Ok. Peter is working out a couple of patches to support multiple PMU. His patches
change pmu difition and we might move some into the callbacks. That will become
much clearer.

Yanmin



