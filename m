Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1HWPny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:43:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41248 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752070Ab1HWPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:43:45 -0400
Date: Tue, 23 Aug 2011 11:43:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Michal Nazarewicz <mnazarewicz@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with "max_speed"
In-Reply-To: <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1108231141400.2069-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Felipe Balbi wrote:

> Hi,
> 
> On Tue, Aug 23, 2011 at 10:37:23AM -0400, Alan Stern wrote:
> > On Tue, 23 Aug 2011, Michal Nazarewicz wrote:
> > 
> > > My understanding was that one could consciously create a composite gadget
> > > such that not all of the functions support all of the speeds.
> > 
> > That's an important point.  If somebody wants to build a composite 
> > gadget that includes both midi and storage support, the storage driver 
> > would be able to go all the way up to SuperSpeed (or rather, it will 
> > once Felipe's patch is finished and merged) but the midi driver would 
> > only support full speed.  So what speed should the UDC connect at?
> 
> if they are both part of the of the same configuration, full speed.
> Otherwise Audio won't work. If they are part of different
> configurations, then maximum_speed will be defined by the chosen config,
> no ?

No.  The speed has to be chosen first, when the gadget connects to the 
host.  The config isn't chosen until later, after the host retrieves 
the various descriptors and decides among them.

> > In cases like this there's really no way to know.  Ultimately the best 
> > approach would be to update the midi driver, but that's a long-term 
> > sort of thing.
> 
> yeah, I agree here.
> 
> > Usually when the kernel can't decide something, it asks the user for 
> > help (by allowing the user to specify the speed via a module parameter, 
> > for instance).  In this case even that wouldn't work, because the 
> > gadget's userspace isn't aware of which functions the host's user will 
> > want to utilize.
> > 
> > At the moment I don't know the best answer.  This is something we 
> > should all think about.
> 
> I stand with the fact that if they are part of the same configuration,
> there's no way around it, storage will have to come down to full speed.
> Unless I'm missing something.

What if they are in different configurations?

Alan Stern

