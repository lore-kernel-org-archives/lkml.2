Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab1BAOXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:23:36 -0500
Received: from sh.osrg.net ([192.16.179.4]:34784 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab1BAOXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:23:35 -0500
Date: Tue, 1 Feb 2011 23:18:54 +0900
To: tj@kernel.org
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, James.Bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com,
        rcj@linux.vnet.ibm.com
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd
 workqueue
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110201104043.GH14211@htj.dyndns.org>
References: <AANLkTi=Fg8wjf-XfVsq0X4RWx7i8F1V7gC6-8Y5LPbnL@mail.gmail.com>
	<20110124162414.GD27510@htj.dyndns.org>
	<20110201104043.GH14211@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110201231836D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 01 Feb 2011 23:18:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 11:40:43 +0100
Tejun Heo <tj@kernel.org> wrote:

> On Mon, Jan 24, 2011 at 05:24:14PM +0100, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Jan 24, 2011 at 05:09:18PM +0100, Bart Van Assche wrote:
> > > Insertion of  flush_work_sync() fixes a race - that's a good catch.
> > > flush_work_sync() should be invoked a little earlier though because
> > > the scheduled work may access the queue destroyed by the
> > > crq_queue_destroy(target) call. And the CRQ interrupt should be
> > > disabled from before flush_work_sync() is invoked until after the CRQ
> > > has been destroyed.
> > 
> > Heh, I'm a bit out of my depth here.  If you know what's necessary,
> > please go ahead and make the change.
> > 
> > > Regarding the queue removal: I might have missed something, but why
> > > would you like to remove the vtgtd work queue ? Since the ibmvstgt
> > > driver is a storage target driver, processing latency matters. I'm
> > > afraid that switching from a dedicated queue to the global work queue
> > > will increase processing latency.
> > 
> > Having a dedicated workqueue no longer makes any difference regarding
> > processing latency.  Each workqueue is mere frontend to the shared
> > worker pool anyway.  Dedicated workqueues are now meaningful only as
> > forward progress guarantee, attribute and/or flush domain - IOW, when
> > the workqueue needs to be used during memory reclaim, the work items
> > need to have specific attributes or certain group of work items need
> > to be flushed together.  Apart from that, there's virtually no
> > difference between using the system_wq and a dedicated one.  As using
> > the system one is usually simpler, it's natural to do that.
> 
> Ping.  Are you interested in doing the conversion?

FYI, this driver will be replaced shortly. Now I have the working
ibmvscsis driver for the new target framework. I'll submit it this
week. So this driver will be removed soon or later (if James prefer to
go through the proper Documentation/feature-removal-schedule.txt
process, it'll be for some time). You could leave this alone, I guess.
