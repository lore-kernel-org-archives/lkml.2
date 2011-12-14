Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab1LNSdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:33:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:55865 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab1LNSdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:33:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86568650"
Subject: Re: [PATCH 2/3] [SCSI]: runtime resume parent for child's
 system-resume
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1112141150520.1707-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1112141150520.1707-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 02:31:52 +0800
Message-ID: <1323887512.7655.3.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 00:51 +0800, Alan Stern wrote:
> On Wed, 14 Dec 2011, Lin Ming wrote:
> 
> > On Wed, Dec 14, 2011 at 11:18 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > > [Patch description from Alan Stern]
> > >
> > > If a child device was runtime-suspended when a system suspend began,
> > > then there will be nothing to prevent its parent from
> > > runtime-suspending as soon as it is woken up during the system resume.
> > > Then when the time comes to resume the child, the resume will fail
> > > because the parent is already back at low power.
> > >
> > > On the other hand, there are some devices which should remain at low
> > > power across an entire suspend-resume cycle. �The details depend on the
> > > device and the platform.
> > >
> > > This suggests that the PM core is not the right place to solve the
> > > problem. �One possible solution is for the subsystem or device driver
> > > to call pm_runtime_get_sync(dev->parent) at the start of the
> > > system-resume procedure and pm_runtime_put_sync(dev->parent) at the
> > > end.
> > >
> > > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > 
> > Hi Alan,
> > 
> > May I add your SOB?
> 
> You can add: Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Did you test this?  Does it do what you want?

Yes, I have tested this and it fixes the problem.

Thanks.

> 
> Alan Stern
> 


