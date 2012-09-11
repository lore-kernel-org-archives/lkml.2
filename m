Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab2IKUtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:49:12 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48174 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab2IKUsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:48:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: runtime PM and special power switches
Date: Tue, 11 Sep 2012 22:55:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "dri-devel" <dri-devel@lists.freedesktop.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
References: <CAPM=9tzq2+LO2BzEmmByeozKzX6nswi1EwvEEM_bgo9kFv1hhA@mail.gmail.com>
In-Reply-To: <CAPM=9tzq2+LO2BzEmmByeozKzX6nswi1EwvEEM_bgo9kFv1hhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209112255.10486.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, September 11, 2012, Dave Airlie wrote:
> Hi Rafael,
> 
> I've been investigating runtime PM support for some use-cases on GPUs.
> 
> In some laptops we have a secondary GPU (optimus) that can be powered
> up for certain 3D tasks and then turned off when finished with. Now I
> did an initial pass on supporting it without using the kernel runtime
> PM stuff, but Alan said I should take a look so here I am.

Alan Stern or Alan Cox? :-)

> While I've started to get a handle on things, we have a bit of an
> extra that I'm not sure we cater for.
> 
> Currently we get called from the PCI layer which after we are finished
> with our runtime suspend callback, will go put the device into the
> correct state etc, however on these optimus/powerxpress laptops we
> have a separate ACPI or platform driver controlled power switch that
> we need to call once the PCI layer is finished the job. This switch
> effectively turns the power to the card completely off leaving it
> drawing no power.
> 
> No we can't hit the switch from the driver callback as the PCI layer
> will get lost, so I'm wondering how you'd envisage we could plug this
> in.

Hmm.  In principle we might modify pci_pm_runtime_suspend() so that it
doesn't call pci_finish_runtime_suspend() if pci_dev->state_saved is
set.  That would actually make it work in analogy with pci_pm_suspend_noirq(),
so perhaps it's not even too dangerous.

Thanks,
Rafael
