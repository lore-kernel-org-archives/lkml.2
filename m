Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2KIQlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:41:55 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55370 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753896Ab2KIQlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:41:53 -0500
Date: Fri, 9 Nov 2012 11:41:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <1352428604.7176.103.camel@yhuang-dev>
Message-ID: <Pine.LNX.4.44L0.1211091131190.1702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Huang Ying wrote:

> On Thu, 2012-11-08 at 12:07 -0500, Alan Stern wrote:
> > On Thu, 8 Nov 2012, Rafael J. Wysocki wrote:
> > 
> > > > > > is it a good idea to allow to set device state to SUSPENDED if the device
> > > > > > is disabled?
> > > > > 
> > > > > No, it is not.  The status should always be ACTIVE as long as usage_count > 0.
> > 
> > That isn't strictly true, because pm_runtime_get_noresume violates this
> > rule.  What the PM core actually does is prevent a transition from the
> > ACTIVE state to the SUSPENDING/SUSPENDED state if usage_count > 0,
> > _provided_ runtime PM is enabled.  There's no such restriction when it
> > is disabled.
> 
> Usage count may be not a issue for the end user.  But "on" in "control"
> sysfs file + SUSPENDED can be confusing for the end user.  Maybe we need
> to check dev->power.runtime_auto in pm_runtime_set_suspended().

You are confusing the issue by raising two separate (though related)
questions.

The first question: How should the PCI subsystem prevent the parents of 
driverless VGA devices from being runtime suspended while userspace is 
accessing them?

The second question: Should the PM core allow devices that are disabled
for runtime PM to be in the SUSPENDED state when
dev->power.runtime_auto is clear?

Assuming we don't want to allow this, there's a third question: Should
pm_runtime_allow call pm_runtime_set_suspended if the device is
disabled?

Alan Stern

