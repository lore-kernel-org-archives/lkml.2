Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2KTQEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:04:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41045 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752312Ab2KTQEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:04:36 -0500
Date: Tue, 20 Nov 2012 11:04:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Huang Ying <ying.huang@intel.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] PCI/PM: Keep runtime PM enabled for unbound PCI devices
In-Reply-To: <1353398902-21253-1-git-send-email-ying.huang@intel.com>
Message-ID: <Pine.LNX.4.44L0.1211201104100.1692-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012, Huang Ying wrote:

> For unbound PCI devices, what we need is:
> 
>  - Always in D0 state, because some devices does not work again after
>    being put into D3 by the PCI bus.
> 
>  - In SUSPENDED state if allowed, so that the parent devices can still
>    be put into low power state.
> 
> To satisfy these requirement, the runtime PM for the unbound PCI
> devices are disabled and set to SUSPENDED state.  One issue of this
> solution is that the PCI devices will be put into SUSPENDED state even
> if the SUSPENDED state is forbidden via the sysfs interface
> (.../power/control) of the device.  This is not an issue for most
> devices, because most PCI devices are not used at all if unbounded.
> But there are exceptions.  For example, unbound VGA card can be used
> for display, but suspend its parents make it stop working.
> 
> To fix the issue, we keep the runtime PM enabled when the PCI devices
> are unbound.  But the runtime PM callbacks will do nothing if the PCI
> devices are unbound.  This way, we can put the PCI devices into
> SUSPENDED state without put the PCI devices into D3 state.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

