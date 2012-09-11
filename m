Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab2IKVc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 17:32:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33296 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758048Ab2IKVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 17:32:24 -0400
Date: Tue, 11 Sep 2012 17:32:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, <linux-pci@vger.kernel.org>
Subject: Re: runtime PM and special power switches
In-Reply-To: <201209112255.10486.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1209111730340.22718-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Rafael J. Wysocki wrote:

> Hi,
> 
> On Tuesday, September 11, 2012, Dave Airlie wrote:
> > Hi Rafael,
> > 
> > I've been investigating runtime PM support for some use-cases on GPUs.
> > 
> > In some laptops we have a secondary GPU (optimus) that can be powered
> > up for certain 3D tasks and then turned off when finished with. Now I
> > did an initial pass on supporting it without using the kernel runtime
> > PM stuff, but Alan said I should take a look so here I am.
> 
> Alan Stern or Alan Cox? :-)
> 
> > While I've started to get a handle on things, we have a bit of an
> > extra that I'm not sure we cater for.
> > 
> > Currently we get called from the PCI layer which after we are finished
> > with our runtime suspend callback, will go put the device into the
> > correct state etc, however on these optimus/powerxpress laptops we
> > have a separate ACPI or platform driver controlled power switch that
> > we need to call once the PCI layer is finished the job. This switch
> > effectively turns the power to the card completely off leaving it
> > drawing no power.
> > 
> > No we can't hit the switch from the driver callback as the PCI layer
> > will get lost, so I'm wondering how you'd envisage we could plug this
> > in.
> 
> Hmm.  In principle we might modify pci_pm_runtime_suspend() so that it
> doesn't call pci_finish_runtime_suspend() if pci_dev->state_saved is
> set.  That would actually make it work in analogy with pci_pm_suspend_noirq(),
> so perhaps it's not even too dangerous.

This sounds more like a job for a power domain.  Unless the power
switch is already in the device hierarchy as a parent to the PCI
device.

Alan Stern

