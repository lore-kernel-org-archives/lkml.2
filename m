Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab2HUQuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:50:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:7400 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133Ab2HUQuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:50:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,803,1336374000"; 
   d="scan'208";a="207642873"
Date: Wed, 22 Aug 2012 00:50:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: scheduling while atomic, under native_smp_prepare_cpus()
Message-ID: <20120821165006.GA24559@localhost>
References: <20120817134944.GA539@localhost>
 <50320163.5080703@linux.vnet.ibm.com>
 <20120820092744.GA3668@localhost>
 <5032067E.20505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5032067E.20505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 05:42:22PM +0800, Michael Wang wrote:
> On 08/20/2012 05:27 PM, Fengguang Wu wrote:
> > Hi Michael,
> > 
> > On Mon, Aug 20, 2012 at 05:20:35PM +0800, Michael Wang wrote:
> >> On 08/17/2012 09:49 PM, Fengguang Wu wrote:
> >>
> >> Hi, FengGuang
> >>
> >> native_smp_prepare_cpus has already disabled the preempt before
> >> reach __irq_alloc_descs(), and sleep in mutex_lock() cause the bug.
> >>
> >> May be the follow patch could help to solve the issue(actually I
> >> think the true problem should be in _cond_resched...).
> > 
> > Is this a debug patch? Since what it does is to conditionally disable
> > the warning.
> 
> No, I use this as a solution, it should work as the bug reported in boot
> process before init_post called.
> 
> We have some reference from __might_sleep which also avoid the check if
> system has not fully booted, so I think this way is acceptable, but I'm
> not the one to make decision...

Fair enough.

> > 
> >> I can't do test by my self since I can't reproduce the issue on my
> >> machine, the kernel_init thread never got a need sched flag set at
> >> that moment in my case...
> > 
> > I'll try it and report back :)
> 
> Appreciate :)

It works! :)

Tested-by: Fengguang Wu <wfg@linux.intel.com>

Thanks,
Fengguang
