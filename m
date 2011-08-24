Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1HXObb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:31:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50528 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751695Ab1HXOb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:31:27 -0400
Date: Wed, 24 Aug 2011 10:31:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with "max_speed"
In-Reply-To: <op.v0pywi0nvgw7ix@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108241028370.2010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Michal Nazarewicz wrote:

> On Tue, 23 Aug 2011 22:49:37 +0200, Alan Stern <stern@rowland.harvard.edu>  
> wrote:
> > Still, maybe I was wrong.  Maybe it would be better to use the fastest
> > speed supported by at least one of the function drivers.  The user can
> > always force a SuperSpeed-capable device to run at high speed by using
> > a USB-2 cable to plug it in.  I'm not sure whether the user could force
> > such a device to run at full speed, however.
> 
> I'm actually wondering whether we really need to worry about it.
> composite_driver has the “max_speed” field and I would just leave it as
> composite driver's author responsibility to put correct value there.
> 
> One thing that could be worth doing is iterate over all the configurations
> and figure out if at least one supports the speed declared by “max_speed”
> and if not, lower it.

That's the same as what I said: Use the highest speed supported by any 
function driver.  There really isn't any point in allowing connections 
faster than that.  And as Felipe pointed out, the user always has the 
capability to force the connection to be slower, by using the right 
sorts of cables and hubs.

> Like I've said before, as additional functionality, composite.c could
> check if it's USB_SPEED_UNKWONW in which case it would look for the lowest
> speed that all the functions support.
> 
> Such configuration would allow composite driver authors set the speed to
> USB_SPEED_SUPER when they mean “choose maximum speed at least one function
> supports” and to “USB_SPEED_UNKWONW” when they mean “choose maximum speed
> all the functions support”.
> 
> Does that make sense?

It's reasonable.  Just be sure to document it properly; otherwise 
nobody will understand or remember it!

Alan Stern

