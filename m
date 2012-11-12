Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2KLAht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 19:37:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:1543 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab2KLAhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 19:37:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="218056656"
Message-ID: <1352680649.7176.140.camel@yhuang-dev>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Mon, 12 Nov 2012 08:37:29 +0800
In-Reply-To: <Pine.LNX.4.44L0.1211091131190.1702-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1211091131190.1702-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-09 at 11:41 -0500, Alan Stern wrote:
> On Fri, 9 Nov 2012, Huang Ying wrote:
> 
> > On Thu, 2012-11-08 at 12:07 -0500, Alan Stern wrote:
> > > On Thu, 8 Nov 2012, Rafael J. Wysocki wrote:
> > > 
> > > > > > > is it a good idea to allow to set device state to SUSPENDED if the device
> > > > > > > is disabled?
> > > > > > 
> > > > > > No, it is not.  The status should always be ACTIVE as long as usage_count > 0.
> > > 
> > > That isn't strictly true, because pm_runtime_get_noresume violates this
> > > rule.  What the PM core actually does is prevent a transition from the
> > > ACTIVE state to the SUSPENDING/SUSPENDED state if usage_count > 0,
> > > _provided_ runtime PM is enabled.  There's no such restriction when it
> > > is disabled.
> > 
> > Usage count may be not a issue for the end user.  But "on" in "control"
> > sysfs file + SUSPENDED can be confusing for the end user.  Maybe we need
> > to check dev->power.runtime_auto in pm_runtime_set_suspended().
> 
> You are confusing the issue by raising two separate (though related)
> questions.

Thanks for clarify.

> The first question: How should the PCI subsystem prevent the parents of 
> driverless VGA devices from being runtime suspended while userspace is 
> accessing them?

I think Rafael's patch is good for that.

> The second question: Should the PM core allow devices that are disabled
> for runtime PM to be in the SUSPENDED state when
> dev->power.runtime_auto is clear?

I think that should not be allowed.

> Assuming we don't want to allow this, there's a third question: Should
> pm_runtime_allow call pm_runtime_set_suspended if the device is
> disabled?

Is it absolute necessary to call pm_runtime_set_suspended?  If the
device is disabled, the transition to SUSPENDED state will not be
triggered even if the device is ACTIVE.

Best Regards,
Huang Ying


