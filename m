Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2KLCgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:36:08 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49659 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751764Ab2KLCgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:36:06 -0500
Date: Sun, 11 Nov 2012 21:36:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <1352680649.7176.140.camel@yhuang-dev>
Message-ID: <Pine.LNX.4.44L0.1211112131500.16611-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Huang Ying wrote:

> > The first question: How should the PCI subsystem prevent the parents of 
> > driverless VGA devices from being runtime suspended while userspace is 
> > accessing them?
> 
> I think Rafael's patch is good for that.

But his patch isn't needed if we make these other changes.

> > The second question: Should the PM core allow devices that are disabled
> > for runtime PM to be in the SUSPENDED state when
> > dev->power.runtime_auto is clear?
> 
> I think that should not be allowed.

Disallowing it is okay with me too.  But it will require several 
changes to the code, more than what your patch did.

> > Assuming we don't want to allow this, there's a third question: Should
> > pm_runtime_allow call pm_runtime_set_suspended if the device is
> > disabled?
> 
> Is it absolute necessary to call pm_runtime_set_suspended?  If the
> device is disabled, the transition to SUSPENDED state will not be
> triggered even if the device is ACTIVE.

It's not absolutely necessary to do this, but we ought to because it 
will allow the device's parent to be suspended.  If we leave the device 
in the ACTIVE state then the parent can't be suspended, even when the 
device is disabled.

Alan Stern

