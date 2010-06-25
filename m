Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab0FYJag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:30:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:35988 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab0FYJaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:30:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,480,1272870000"; 
   d="scan'208";a="811542987"
Subject: Re: [RFC][PATCH] irq_work
From: Huang Ying <ying.huang@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <AANLkTikEpj6EkJJ2dWs12JiODF8pl4foYq_AZtzxP2ef@mail.gmail.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
	 <1277452110.22715.2116.camel@twins>
	 <1277457439.3947.184.camel@yhuang-dev.sh.intel.com>
	 <AANLkTikEpj6EkJJ2dWs12JiODF8pl4foYq_AZtzxP2ef@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 17:30:32 +0800
Message-ID: <1277458232.3947.186.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 17:23 +0800, Frederic Weisbecker wrote:
> 2010/6/25 Huang Ying <ying.huang@intel.com>:
> > On Fri, 2010-06-25 at 15:48 +0800, Peter Zijlstra wrote:
> >> On Fri, 2010-06-25 at 10:12 +0800, Huang Ying wrote:
> >> >
> >> > It is better to add "void *data" field in this struct to allow same
> >> > function can be used for multiple struct irq_work.
> >>
> >> No, simply do:
> >>
> >> struct my_foo {
> >>   struct irq_work work;
> >>   /* my extra data */
> >> }
> >>
> >> void my_func(struct irq_work *work)
> >> {
> >>   struct my_foo *foo = container_of(work, struct my_foo, work);
> >>
> >>   /* tada! */
> >> }
> >
> > Yes. This works too. But Adding "void *data" field is helpful if you do
> > not embed struct irq_work into another struct.
>
> 
> That's what makes most sense. If you use work->data to put foo, then
> you can also do the opposite. Now the best is to pick the choice that
> gives you a real type and a typechecking, and not an error-prone and
> obfuscated void *
> 
> This is the way things are made in the kernel. struct work_struct, struct list,
> struct rcu_head, etc... are all embedded into a container, so that we can
> use container_of.

container_of has no full type checking too.

Best Regards,
Huang Ying


