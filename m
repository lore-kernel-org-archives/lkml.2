Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1F3PTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:19:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38756 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750881Ab1F3PTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:19:10 -0400
Date: Thu, 30 Jun 2011 11:19:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
In-Reply-To: <Pine.LNX.4.44L0.1106291720330.2064-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1106301110330.1957-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Alan Stern wrote:

> On Wed, 29 Jun 2011, Arkadiusz Miskiewicz wrote:
> 
> > On Wednesday 29 of June 2011, Alan Stern wrote:
> > > On Wed, 29 Jun 2011, Arkadiusz Miskiewicz wrote:
> > > > Hi,
> > > > 
> > > > Something broke between rc3 and rc5. Thinkpad t400, logitech usb mouse.
> > > > After resume from ram usb device no longer works. Somewhere around rc3 it
> > > > was working fine.
> > > 
> > > Obviously you can try bisection to find the problem.  But if you don't
> > > want to go through that, you could post the dmesg from a kernel that
> > > has CONFIG_USB_DEBUG enabled.
> > 
> > CONFIG_USB_DEBUG will be faster but I'll bisect if no one figures out what's 
> > wrong.
> 
> Actually bisection might end up being quicker.  This looks like a
> pretty tricky problem.  Maybe you should start a bisection while I look 
> at this stuff; you'll probably reach an answer before I do!
> 
> > Note that I tried to unplug & plugin usb mouse after all this dmesg but 
> > nothing new appeared in dmesg - kernel didn't notice that I did that.

The log suggests that something went wrong somewhere around here:

[   73.811538] usb 2-4: unregistering interface 2-4:1.7
[   73.811594] cdc_ether 2-4:1.7: wwan0: unregister 'cdc_ether' usb-0000:00:1d.7-4, Mobile Broadband Network Device
[   73.823457] done.
[   73.823470] video LNXVIDEO:00: Restoring backlight state
[   74.056070] usb usb3: suspend_rh (auto-stop)

(I don't have any idea what that "done" refers to.)  There should have
been additional messages about unregistering interfaces 2-4:1.8,
2-4:1.9, and 2-4:1.10.  So perhaps the cdc_ether unregistration got
hung up.  Can you get a stack trace for the khubd thread at this point?

Also, you can try unloading cdc-ether before starting the suspend to
see if that makes any difference.

Alan Stern

