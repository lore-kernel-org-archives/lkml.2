Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1JKOEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:04:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56935 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750942Ab1JKOEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:04:30 -0400
Date: Tue, 11 Oct 2011 10:04:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <khilman@ti.com>, <b-cousson@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <20111011081352.GC10155@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1110111000460.2177-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Felipe Balbi wrote:

> > > It doesn't shown here, but the TLL link is completely optional. It's
> > > mainly used for modem integration, IIRC. Still, if we're using TLL, EHCI
> > > and OHCI will depend on a clock provided by the USBTLL block.
> > > 
> > > Clearly, USBTLL isn't either a parent of UHH, nor a parent of EHCI/OHCI
> > > blocks. We can, from a code perspective, make USBTLL into a parent of
> > > UHH to make things simpler, but this will mean that calling
> > > pm_runtime_get() will also unconditionaly turn on TLL clock, unless we
> > > add some nasty hacks to allow TLL know if *HCI port is in TLL mode.
> > > 
> > > That's why I decided for making TLL and UHH siblings, because that's a
> > > closer relationship than parent-child.
> > > 
> > > Can you see the problem now ?
> > 
> > Okay, now I understand better.  The word "sibling" implies that the two 
> > objects have the same parent, so a different word would describe this 
> > relationship better.  Something like "friend" or "associate".
> > 
> > Or maybe, following Paul's suggestion, the driver core doesn't have to 
> > be changed at all.
> 
> I see... I just thought that if there are other similar cases, it might
> make sense to have a more generic way to make those two devices talk to
> each other. But if you all agree that an EXPORT_SYMBOL_GPL() is enough,
> then it's ok ;-)

At the moment, I can't see any way to set up a more generic mechanism 
that wouldn't be more complicated and have higher overhead than a 
simple EXPORT_SYMBOL_GPL.

Can this be handled by adding another resource to a platform_device?  
That at least would make use of an already-existing mechanism.

Alan Stern

