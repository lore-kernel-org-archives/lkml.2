Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0FWBN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 21:13:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:63278 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab0FWBNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 21:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,463,1272870000"; 
   d="scan'208";a="632729495"
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C206D3E.3060506@redhat.com>
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>
	 <4C1F50D0.70205@redhat.com>
	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>
	 <4C2062D8.20609@redhat.com>
	 <1277192873.2096.690.camel@ymzhang.sh.intel.com>
	 <4C206D3E.3060506@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 23 Jun 2010 09:13:44 +0800
Message-Id: <1277255624.2096.728.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 09:58 +0200, Jes Sorensen wrote:
> On 06/22/10 09:47, Zhang, Yanmin wrote:
> > On Tue, 2010-06-22 at 09:14 +0200, Jes Sorensen wrote:
> >> On 06/22/10 03:49, Zhang, Yanmin wrote:
> >>> On Mon, 2010-06-21 at 14:45 +0300, Avi Kivity wrote:
> >>> So I think above discussion is around how to expose PMU hardware to guest os. I will
> >>> also check this method after the para virt interface is done.
> >>
> >> You should be able to expose the counters as read-only to the guest. KVM
> >> allows you to specify whether or not a guest has read, write or
> >> read/write access. If you allowed read access of the counters that would
> >> safe a fair bit of hyper calls.
> > Thanks. KVM is good in register access permission configuration. But things are not so
> > simple like that if we consider real running environment. Host kernel might schedule
> > guest os vcpu thread to other cpus, or other non-kvm processes might preempt the vcpu
> > thread on this cpu.
> > 
> > To support such capability you said, we have to implement the direct exposition of PMU
> > hardware to guest os eventually.
> 
> If the guest is rescheduled to another CPU, or you get a preemption, you
> have a VMEXIT. The vcpu thread will not migrate while it is running, so
> you can handle it while the the VMEXIT is being serviced.
> 
> Exposing the counters read-only would save a lot of overhead for sure.
> >> Question is if it is safe to drop overflow support?
> > Not safe. One of PMU hardware design objectives is to use interrupt or NMI to notify
> > software when event counter overflows. Without overflow support, software need poll
> > the PMU registers looply. That is not good and consumes more cpu resources.
> 
> Here is an idea, how about having the overflow NMI in the host trigger a
> flag that causes the PMU register read to trap and get special handling?
> That way you could propagate the overflow back down to the guest.
That doesn't resolve the issue that guest os software has to poll register.


