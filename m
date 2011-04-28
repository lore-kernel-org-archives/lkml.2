Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1D1FNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 01:13:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:43421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab1D1FNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 01:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,278,1301900400"; 
   d="scan'208";a="635156456"
Subject: Re: [RFC]block: add flush request at head
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20110426112905.GC878@htj.dyndns.org>
References: <1303112174.3981.187.camel@sli10-conroe>
	 <4DABF194.4010603@fusionio.com> <1303115157.3981.198.camel@sli10-conroe>
	 <20110422225704.GA1576@mtj.dyndns.org>
	 <1303693319.3981.272.camel@sli10-conroe>
	 <20110425082103.GA17734@mtj.dyndns.org>
	 <1303778955.3981.285.camel@sli10-conroe>
	 <20110426112905.GC878@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 13:13:36 +0800
Message-ID: <1303967616.3981.429.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 19:29 +0800, Tejun Heo wrote:
Hi Thejun,
> On Tue, Apr 26, 2011 at 08:49:15AM +0800, Shaohua Li wrote:
> > On Mon, 2011-04-25 at 16:21 +0800, Tejun Heo wrote:
> > > Hello, Shaohua.
> > > 
> > > On Mon, Apr 25, 2011 at 09:01:59AM +0800, Shaohua Li wrote:
> > > > this is a regression from 2.6.39-rc2 compared to 2.6.39-rc1, so this
> > > > isn't related to the flush rewritten. Workload is sysbench fileio,
> > > > please see the first mail at the thread for detail.
> > > 
> > > Understood.  Let's talk on the other thread.
> >
> > This issue isn't related to the optimization patch in another thread.
> > And that patch can't recover the regression, which does improve
> > throughput even without the regression. So please look at issue again.
> 
> IIUC, the regression happened because, before, back-to-back flushes
> were basically optimized out by hardware but, after, due to regular
> writes thrown into the mix, aren't.  If that's the case, I would still
> prefer to solve this from issue side instead of completion if possible
> (it might not be tho).
> 
> Or is the latency introduced for each flush actually making difference
> for the specific benchmark?  Hmmm... maybe that's the case given that
> your patches merging back-to-back flushes doesn't recover the whole
> regression.
The reason is quite subtle ad the queue just has two requests at most
time. Say we have f1, w1, f2, f1 is running and f2 is requeued.
Without the regression, we run f1, f2, w1
with the regression, we run f1, w1, f2
Without the regression, f2 finishes quite quickly and it appears we run
more writes before run a flush.

If you want to check the problem, you should use sata, which gives a lot
of requeue. high-end drive might not be good to investigate the problem.

Thanks,
Shaohua

