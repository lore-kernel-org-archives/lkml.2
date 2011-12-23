Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab1LWSin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:38:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:20815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1LWSil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:38:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99761527"
Subject: Re: [tip:sched/urgent] sched: Fix select_idle_sibling() regression
 in selecting an idle SMT sibling
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Date: Fri, 23 Dec 2011 10:43:34 -0800
In-Reply-To: <1324520161.17054.190.camel@debian>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
	 <tip-ab2789213d224202237292d78aaa0c386c7b28b2@git.kernel.org>
	 <CAGjg+kEOkkjnQQJJyGQzGApV5asM5oqvRwEr2VkJy9G5gg1rxw@mail.gmail.com>
	 <1324471944.10752.8.camel@twins>
	 <1324496556.21294.11.camel@sbsiddha-desk.sc.intel.com>
	 <1324517502.17054.174.camel@debian>
	 <1324519393.21294.20.camel@sbsiddha-desk.sc.intel.com>
	 <1324520161.17054.190.camel@debian>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1324665814.4167.32.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 18:16 -0800, Shi, Alex wrote:
> On Thu, 2011-12-22 at 10:03 +0800, Siddha, Suresh B wrote:
> > On Wed, 2011-12-21 at 17:31 -0800, Shi, Alex wrote:
> > > This patch partly fixed a performance regression that triggered by
> > > 4dcfe1025b513c2c, but issue still exists.
> > 
> > So how much was the regression caused by the commit 4dcfe1025b513c2c and
> > how much did we recover with this fix I posted. If we are talking about
> > the regression caused by this single commit 4dcfe1025b513c2c, then I
> > don't know of any other related fixes other than the recent fix we
> > pushed upstream (ab2789213d224202237292d78aaa0c386c7b28b2).
> 
> A little complex for the whole thing. 
> on 4 sockets EX machine, 3~5% hackbench thread regression due to 4dcfe
> can be recovered by ab2789. 
> 
> But on 2 sockets SNB machine, 1024 clients loop netperf TCP-RR has about
> 9% regression. and your patch seem recover 2~3%. 
> 
> And on a 2 sockets nhm, one of our private benchmark was impact much 20
> +% regression. that benchmark just run 4 process, each of process open a
> thread, and the thread tasks is to locate randomly pages and than read
> from 4 times/write 1 time data into a page.  The ab2789 commit seems no
> help our benchmark. 

Ok. Can you please try couple of experiments with two kernels? Two
kernels being the base kernel (prior to 4dcfe1025b513c2c) and the second
kernel with the commit ab2789213d224202237292d78aaa0c386c7b28b2.

One experiment with p-states turned off and the second experiment with
c-states turned off.

I suspect mostly deeper core c-states might be contributing to the
behavior that you are seeing.

thanks,
suresh

