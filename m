Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0DNKOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:14:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:48184 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab0DNKOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,203,1270450800"; 
   d="scan'208";a="612980163"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os statistics from host side
Date: Wed, 14 Apr 2010 18:14:19 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <201004141743.32393.sheng@linux.intel.com> <4BC5919E.1010400@redhat.com>
In-Reply-To: <4BC5919E.1010400@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004141814.19330.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 April 2010 17:57:50 Avi Kivity wrote:
> On 04/14/2010 12:43 PM, Sheng Yang wrote:
> > On Wednesday 14 April 2010 17:20:15 Avi Kivity wrote:
> >> On 04/14/2030 12:05 PM, Zhang, Yanmin wrote:
> >>> Here is the new patch of V3 against tip/master of April 13th
> >>> if anyone wants to try it.
> >>
> >> Thanks for persisting despite the flames.
> >>
> >> Can you please separate arch/x86/kvm part of the patch?  That will make
> >> for easier reviewing, and will need to go through separate trees.
> >>
> >> Sheng, did you make any progress with the NMI injection issue?
> >
> > Yes, though some other works interrupt me lately...
> >
> > The very first version has issue due to SELF_IPI mode can't be used to
> > send NMI according to SDM. That's the reason why x2apic don't have way to
> > do this.
> 
> Yes, I see that now.  Looks like others have the same questions...
> 
> > But later I found another issue of fail to inspect inside the guest. I
> > think it's due to NMI is asynchronous event, though it should be
> > triggered very quickly, you can't guarantee that the handler would be
> > triggered before the state(current_vcpu) is cleared with current code.
> >
> > Maybe just extended the "guest state" region would be fine, if the
> > latency is stable enough(though I think it maybe platform depended). I am
> > working on this now.
> 
> I wouldn't like to depend on model specific behaviour.
>
> One option is to read all the information synchronously and store it in
> a per-cpu area with atomic instructions, then queue the NMI.  Another
> option is to have another callback which tells us that the NMI is done,
> and have a busy loop wait until the NMI is delivered.
> 
Callback seems too heavy, may affect the performance badly. Maybe a short 
queue would help, though this one is more complex.

But I am still curious if we extend the region, how much it would help. Would 
get a result soon...

-- 
regards
Yang, Sheng
