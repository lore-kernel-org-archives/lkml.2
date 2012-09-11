Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2IKWQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:16:52 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48292 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2IKWQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:16:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: runtime PM and special power switches
Date: Wed, 12 Sep 2012 00:23:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "dri-devel" <dri-devel@lists.freedesktop.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
References: <Pine.LNX.4.44L0.1209111730340.22718-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1209111730340.22718-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209120023.11662.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 11, 2012, Alan Stern wrote:
> On Tue, 11 Sep 2012, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > On Tuesday, September 11, 2012, Dave Airlie wrote:
> > > Hi Rafael,
> > > 
> > > I've been investigating runtime PM support for some use-cases on GPUs.
> > > 
> > > In some laptops we have a secondary GPU (optimus) that can be powered
> > > up for certain 3D tasks and then turned off when finished with. Now I
> > > did an initial pass on supporting it without using the kernel runtime
> > > PM stuff, but Alan said I should take a look so here I am.
> > 
> > Alan Stern or Alan Cox? :-)
> > 
> > > While I've started to get a handle on things, we have a bit of an
> > > extra that I'm not sure we cater for.
> > > 
> > > Currently we get called from the PCI layer which after we are finished
> > > with our runtime suspend callback, will go put the device into the
> > > correct state etc, however on these optimus/powerxpress laptops we
> > > have a separate ACPI or platform driver controlled power switch that
> > > we need to call once the PCI layer is finished the job. This switch
> > > effectively turns the power to the card completely off leaving it
> > > drawing no power.
> > > 
> > > No we can't hit the switch from the driver callback as the PCI layer
> > > will get lost, so I'm wondering how you'd envisage we could plug this
> > > in.
> > 
> > Hmm.  In principle we might modify pci_pm_runtime_suspend() so that it
> > doesn't call pci_finish_runtime_suspend() if pci_dev->state_saved is
> > set.  That would actually make it work in analogy with pci_pm_suspend_noirq(),
> > so perhaps it's not even too dangerous.
> 
> This sounds more like a job for a power domain.  Unless the power
> switch is already in the device hierarchy as a parent to the PCI
> device.

Good idea. :-)

Thanks,
Rafael
