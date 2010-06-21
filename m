Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0FUMhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 08:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab0FUMhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 08:37:19 -0400
Message-ID: <4C1F5CF0.4030206@redhat.com>
Date: Mon, 21 Jun 2010 15:37:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Subject: Re: [PATCH V2 5/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112709.2096.513.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277112709.2096.513.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 12:31 PM, Zhang, Yanmin wrote:
> The 5th patch is applied to the latest qemu-kvm tree.
>
> --- qemu-kvm_0621/target-i386/kvm.c	2010-06-21 11:00:29.000000000 +0800
> +++ qemu-kvm_0621_perf/target-i386/kvm.c	2010-06-21 13:00:14.136999850 +0800
> @@ -150,6 +150,9 @@ struct kvm_para_features {
>   #ifdef KVM_CAP_PV_MMU
>           { KVM_CAP_PV_MMU, KVM_FEATURE_MMU_OP },
>   #endif
> +#ifdef KVM_CAP_PV_PERF
> +        { KVM_CAP_PV_PERF, KVM_FEATURE_PV_PERF },
> +#endif
>           { -1, -1 }
>   };
>
>    


Not really necessary any more - if you expose the cpuid bit via 
KVM_GET_SUPPORTED_CPUID2 then 'qemu -cpu host' will automatically enable it.

On the other hand, do update target-i386/cpuid.c:kvm_feature_name so 
people can enable the feature using qemu -cpu ...,+kvmperf.

-- 
error compiling committee.c: too many arguments to function

