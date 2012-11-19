Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2KSV4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:56:20 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:53720 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2KSV4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:56:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC] PCI/PM: Keep runtime PM enabled for unbound PCI devices
Date: Mon, 19 Nov 2012 23:00:43 +0100
Message-ID: <1521498.PJusLS7B2o@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1211191129060.1598-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1211191129060.1598-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 19, 2012 11:31:01 AM Alan Stern wrote:
> On Mon, 19 Nov 2012, Huang Ying wrote:
> 
> > For unbound PCI devices, what we need is:
> > 
> >  - Always in D0 state, because some devices does not work again after
> >    being put into D3 by the PCI bus.
> > 
> >  - In SUSPENDED state if allowed, so that the parent devices can still
> >    be put into low power state.
> > 
> > To satisfy these requirement, the runtime PM for the unbound PCI
> > devices are disabled and set to SUSPENDED state.  One issue of this
> > solution is that the PCI devices will be put into SUSPENDED state even
> > if the SUSPENDED state is forbidden via the sysfs interface
> > (.../power/control) of the device.  This is not an issue for most
> > devices, because most PCI devices are not used at all if unbounded.
> > But there are exceptions.  For example, unbound VGA card can be used
> > for display, but suspend its parents make it stop working.
> > 
> > To fix the issue, we keep the runtime PM enabled when the PCI devices
> > are unbound.  But the runtime PM callbacks will do nothing if the PCI
> > devices are unbound.  This way, we can put the PCI devices into
> > SUSPENDED state without put the PCI devices into D3 state.
> > 
> > Known issue: after some changing, pci_dev->driver is used to indicate
> > whether the PCI devices are bound and whether the runtime PM callbacks
> > should do nothing.  Maybe it is better to use a dedicated flag such as
> > .skip_rtpm_callbacks.  That may improve code readability.
> 
> I think it's okay like this, especially if you add a comment in 
> pci_runtime_suspend, pci_runtime_resume, and pci_runtime_idle 
> explaining that when pci_dev->driver isn't set, the device should 
> always remain in D0 regardless of the runtime status.

Yes, I agree with Alan.  Please add comments as Alan's suggesting and it
should be fine.

Thanks,
Rafael



-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
