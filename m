Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1HWSAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:00:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56326 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751997Ab1HWSA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:00:26 -0400
Date: Tue, 23 Aug 2011 14:00:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Michal Nazarewicz <mnazarewicz@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with "max_speed"
In-Reply-To: <20110823172111.GD10996@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1108231350460.2069-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Felipe Balbi wrote:

> Hi,
> 
> On Tue, Aug 23, 2011 at 11:43:44AM -0400, Alan Stern wrote:
> > > if they are both part of the of the same configuration, full speed.
> > > Otherwise Audio won't work. If they are part of different
> > > configurations, then maximum_speed will be defined by the chosen config,
> > > no ?
> > 
> > No.  The speed has to be chosen first, when the gadget connects to the 
> > host.  The config isn't chosen until later, after the host retrieves 
> > the various descriptors and decides among them.
> 
> true
> 
> > > I stand with the fact that if they are part of the same configuration,
> > > there's no way around it, storage will have to come down to full speed.
> > > Unless I'm missing something.
> > 
> > What if they are in different configurations?
> 
> then you use the fastest speed between both configurations?

I simply don't know.  It's a difficult problem.

For the time being, perhaps the best answer is to use the _lowest_ 
max_speed value among all the function drivers.  It's the simplest 
answer and most likely to be correct most of the time.

If anybody ever does want to put together a composite gadget that runs
faster than full speed but still provides a midi function ... well,
they'll just have to update the midi gadget driver.

(Actually that's a bogus example.  It turns out that gmidi.c doesn't 
support the composite framework.  Oh well.)

Alan Stern

