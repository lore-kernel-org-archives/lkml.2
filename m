Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422789Ab2KNQGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:06:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35763 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161047Ab2KNQGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:06:17 -0500
Date: Wed, 14 Nov 2012 11:06:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <1352900114.5254.3.camel@yhuang-mobile.sh.intel.com>
Message-ID: <Pine.LNX.4.44L0.1211141100030.1620-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Huang Ying wrote:

> > What changes specifically do you mean to be precise?
> 
> I mean the following changes from Alan's email.
> 
>         pm_runtime_set_suspended should fail if dev->power.runtime_auto
>         is clear.
> 
>         pm_runtime_forbid should call pm_runtime_set_active if
>         dev->power.disable_depth > 0.  (This would run into a problem
>         if the parent is suspended and disabled.  Maybe 
>         pm_runtime_forbid should fail when this happens.)
> 
> For the second one, is it possible that the device is really in low
> power state when pm_runtime_forbid is called?  That situation is hard to
> deal with too.

Yes, it is possible.  I don't see what we can do about it.  By
disabling the device, the driver has said that it doesn't want to 
handle any runtime PM callbacks.  Without the driver's help, there 
isn't any good way to bring the device back to full power.

On the other hand, the PM core doesn't know the device's actual power 
state.  All it knows is the value of dev->power.runtime_status.  So it 
doesn't have any way to detect when this problem occurs.

Alan Stern

