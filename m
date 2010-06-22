Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0FVDPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 23:15:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:38436 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0FVDPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 23:15:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,457,1272870000"; 
   d="scan'208";a="578559115"
Subject: Re: [PATCH V2 5/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C1F5CF0.4030206@redhat.com>
References: <1277112709.2096.513.camel@ymzhang.sh.intel.com>
	 <4C1F5CF0.4030206@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 22 Jun 2010 11:15:54 +0800
Message-Id: <1277176554.2096.654.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 15:37 +0300, Avi Kivity wrote:
> On 06/21/2010 12:31 PM, Zhang, Yanmin wrote:
> > The 5th patch is applied to the latest qemu-kvm tree.
> >
> > --- qemu-kvm_0621/target-i386/kvm.c	2010-06-21 11:00:29.000000000 +0800
> > +++ qemu-kvm_0621_perf/target-i386/kvm.c	2010-06-21 13:00:14.136999850 +0800
> > @@ -150,6 +150,9 @@ struct kvm_para_features {
> >   #ifdef KVM_CAP_PV_MMU
> >           { KVM_CAP_PV_MMU, KVM_FEATURE_MMU_OP },
> >   #endif
> > +#ifdef KVM_CAP_PV_PERF
> > +        { KVM_CAP_PV_PERF, KVM_FEATURE_PV_PERF },
> > +#endif
> >           { -1, -1 }
> >   };
> >
> >    
> 
> 
> Not really necessary any more - if you expose the cpuid bit via 
> KVM_GET_SUPPORTED_CPUID2 then 'qemu -cpu host' will automatically enable it.
> 
> On the other hand, do update target-i386/cpuid.c:kvm_feature_name so 
> people can enable the feature using qemu -cpu ...,+kvmperf.
Thanks for the good pointer. I will change it.

Avi,

Thanks for your wonderful comments. I will fix all in the patches.
As for the live migration, I need check it carefully. If you could
provide some suggestions on it, especially about how/when to save all perf_events
and restore all pref_events, that would be very helpful.

Yanmin


