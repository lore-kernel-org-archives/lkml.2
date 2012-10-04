Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2JDH3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:29:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab2JDH3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:29:14 -0400
Date: Thu, 4 Oct 2012 09:29:00 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
Message-ID: <20121004072900.GU23096@redhat.com>
References: <5061713D.5060406@redhat.com>
 <CAJocwcf+8u84_yDC-PK0Yni93YSTWzYvr69nq6b3pNv1MwVJzQ@mail.gmail.com>
 <50641356.5070008@redhat.com>
 <CAJocwcc19F+PtsQ5okGMvYeVnkEigpZRpwWY9JgeRPFqfcVoXA@mail.gmail.com>
 <506540C7.9070105@linux.vnet.ibm.com>
 <50680049.5020206@redhat.com>
 <20120930110755.GB1009@redhat.com>
 <50682945.3060309@redhat.com>
 <20121003141739.GA15253@linux.vnet.ibm.com>
 <506C5239.4080209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506C5239.4080209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:56:57PM +0200, Avi Kivity wrote:
> On 10/03/2012 04:17 PM, Raghavendra K T wrote:
> > * Avi Kivity <avi@redhat.com> [2012-09-30 13:13:09]:
> > 
> >> On 09/30/2012 01:07 PM, Gleb Natapov wrote:
> >> > On Sun, Sep 30, 2012 at 10:18:17AM +0200, Avi Kivity wrote:
> >> >> On 09/28/2012 08:16 AM, Raghavendra K T wrote:
> >> >> > 
> >> >> >>
> >> >> >>     +struct pv_sched_info {
> >> >> >>     +       unsigned long   sched_bitmap;
> >> >> > 
> >> >> > Thinking, whether we need something similar to cpumask here?
> >> >> > Only thing is we are representing guest (v)cpumask.
> >> >> > 
> >> >> 
> >> >> DECLARE_BITMAP(sched_bitmap, KVM_MAX_VCPUS)
> >> >> 
> >> > vcpu_id can be greater than KVM_MAX_VCPUS.
> >> 
> >> Use the index into the vcpu table as the bitmap index then.  In fact
> >> it's better because then the lookup to get the vcpu pointer is trivial.
> > 
> > Did you mean, while setting the bitmap,
> > 
> > we should do 
> > for (i = 1..n)
> > if (kvm->vcpus[i] == vcpu) set ith position in bitmap?
> 
> You can store i in the vcpu itself:
> 
>   set_bit(vcpu->index, &kvm->preempted);
> 
This will make the fact that vcpus are stored in an array into API
instead of implementation detail :( There were patches for vcpu
destruction that changed the array to rculist. Well, it will be still
possible to make the array rcu protected and copy it every time vcpu is
deleted/added I guess.

--
			Gleb.
