Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0FVIZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:25:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0FVIZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:25:18 -0400
Message-ID: <4C20734A.3000008@redhat.com>
Date: Tue, 22 Jun 2010 10:24:42 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com
Subject: Re: [PATCH V2 4/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112706.2096.512.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277112706.2096.512.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/10 11:31, Zhang, Yanmin wrote:
> @@ -583,10 +584,20 @@ static void x86_pmu_disable_all(void)
>  	}
>  }
>  
> +#ifdef CONFIG_KVM_PERF
> +static int kvm_hw_perf_enable(void);
> +static int kvm_hw_perf_disable(void);
> +#endif

Please put these prototypes into a header ... and create dummy stubs for
them when CONFIG_KVM_PERF is not set.

>  void hw_perf_disable(void)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>  
> +#ifdef CONFIG_KVM_PERF
> +	if (!kvm_hw_perf_disable())
> +		return;
> +#endif

If you stub them out we can avoid all the ugly #ifdefs

> @@ -810,6 +821,11 @@ void hw_perf_enable(void)
>  	struct hw_perf_event *hwc;
>  	int i, added = cpuc->n_added;
>  
> +#ifdef CONFIG_KVM_PERF
> +	if (!kvm_hw_perf_enable())
> +		return;
> +#endif

and here....

> @@ -1317,6 +1334,11 @@ void __init init_hw_perf_events(void)
>  
>  	pr_info("Performance Events: ");
>  
> +#ifdef CONFIG_KVM_PERF
> +	if (!kvm_init_hw_perf_events())
> +		return;
> +#endif

and again here :)

Cheers,
Jes


