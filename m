Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1LNQvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:51:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38381 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752045Ab1LNQvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:51:44 -0500
Date: Wed, 14 Dec 2011 11:51:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/3] [SCSI]: runtime resume parent for child's system-resume
In-Reply-To: <CAF1ivSa=AZXr93a+i2VXn9_O-8-ozmPOcFOm9HAMQRd7faC5Cg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1112141150520.1707-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Lin Ming wrote:

> On Wed, Dec 14, 2011 at 11:18 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > [Patch description from Alan Stern]
> >
> > If a child device was runtime-suspended when a system suspend began,
> > then there will be nothing to prevent its parent from
> > runtime-suspending as soon as it is woken up during the system resume.
> > Then when the time comes to resume the child, the resume will fail
> > because the parent is already back at low power.
> >
> > On the other hand, there are some devices which should remain at low
> > power across an entire suspend-resume cycle.  The details depend on the
> > device and the platform.
> >
> > This suggests that the PM core is not the right place to solve the
> > problem.  One possible solution is for the subsystem or device driver
> > to call pm_runtime_get_sync(dev->parent) at the start of the
> > system-resume procedure and pm_runtime_put_sync(dev->parent) at the
> > end.
> >
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> 
> Hi Alan,
> 
> May I add your SOB?

You can add: Acked-by: Alan Stern <stern@rowland.harvard.edu>

Did you test this?  Does it do what you want?

Alan Stern

