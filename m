Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1ESGmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 02:42:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:2576 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab1ESGmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 02:42:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,236,1304319600"; 
   d="scan'208";a="438858712"
From: "Shan, Haitao" <haitao.shan@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 19 May 2011 14:41:43 +0800
Subject: RE: [PATCH v2 0/4] Enable SMEP CPU Feature
Thread-Topic: [PATCH v2 0/4] Enable SMEP CPU Feature
Thread-Index: AcwUho0pQZ9BKQLLSGu3l9k5Ay+SLQBZIliQAADrzjA=
Message-ID: <04F972F38B3C4E4E91C4697DA8BF9F525B208891C9@shsmsx502.ccr.corp.intel.com>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <4DD19C81.8000902@zytor.com> <20110517070527.GD22305@elte.hu>
 <4DD23CB6.3050503@redhat.com> <20110517092903.GJ22093@elte.hu>
 <4DD2409F.4030800@redhat.com> <20110517104654.GN22093@elte.hu>
 <4DD25D29.9040008@redhat.com>
 <625BA99ED14B2D499DC4E29D8138F1505C9BEEF80B@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C9BEEF80B@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this basic enabling work, we could work out a patch to address Ingo's idea, which will mandatorily turn on SMEP for guests.

Shan Haitao

-----Original Message-----
From: Tian, Kevin 
Sent: Thursday, May 19, 2011 2:11 PM
To: Avi Kivity; Ingo Molnar
Cc: H. Peter Anvin; Yu, Fenghua; Thomas Gleixner; Mallick, Asit K; Linus Torvalds; Arjan van de Ven; Andrew Morton; Andi Kleen; linux-kernel; Pekka Enberg; Shan, Haitao
Subject: RE: [PATCH v2 0/4] Enable SMEP CPU Feature

> From: Avi Kivity
> Sent: Tuesday, May 17, 2011 7:34 PM
> 
> On 05/17/2011 01:46 PM, Ingo Molnar wrote:
> > >
> > >  We could support it as a non-default feature, but that reduces its utility.
> >
> > It would be a nice touch for tools/kvm/: we would use KVM_GET_SREGS 
> > and KVM_GET_SREGS to twiddle CR4.SMEP, even without the guest 
> > explicitly
> doing it.
> >
> > A quick glance suggests that it could be done straight away in
> > tools/kvm/kvm-cpu.c::kvm_cpu__setup_sregs() during vcpu setup, and 
> > hopefully that cr4 value survives boot and ends up in the guest 
> > kernel's mmu_cr4_features mask shadow register.
> 
> Depends if the guest uses a read-modify-write pattern or not.  We 
> could do it transparently in kvm.ko, since the real cr4 need not 
> corresponds to the guest notion (for example, we often set cr0.wp or 
> cr0.ts even though the guest wants them clear).
> 

We have a patch in hand now to enable SMEP for kvm guest, which is under test and cleanup and will be sent out soon. Basically it contains the basic idea by exposing CR4.smep and cpuid leaf. Above idea is nice and we'll try that in a following work.

Thanks
Kevin
