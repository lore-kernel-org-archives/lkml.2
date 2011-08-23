Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1HWUtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:49:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41731 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751791Ab1HWUti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:49:38 -0400
Date: Tue, 23 Aug 2011 16:49:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with "max_speed"
In-Reply-To: <op.v0okm8hlvgw7ix@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108231636000.2069-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Michal Nazarewicz wrote:

> On Tue, 23 Aug 2011 20:00:25 +0200, Alan Stern <stern@rowland.harvard.edu>  
> wrote:
> > For the time being, perhaps the best answer is to use the _lowest_
> > max_speed value among all the function drivers.  It's the simplest
> > answer and most likely to be correct most of the time.
> 
> In theory, one could create a composite function with only SS/HS
> descriptors.

The only reason for doing that would be if the function was incapable
of carrying out its duties when running at full speed (insufficient
bandwidth, for example).  Something like this is discussed briefly in 
section 9.2.6.6 of the USB-2 spec.

>  So it would work for SS/HS but not for FS.  I'm not
> saying that it would make sense (or that it's not a bug) but that
> adds to the discussion.

If somebody writes a composite gadget containing two functions, one of 
which supports only full speed and the other only high speed, they'll 
get what they deserve.  :-)

Still, maybe I was wrong.  Maybe it would be better to use the fastest
speed supported by at least one of the function drivers.  The user can
always force a SuperSpeed-capable device to run at high speed by using
a USB-2 cable to plug it in.  I'm not sure whether the user could force
such a device to run at full speed, however.

Alan Stern

