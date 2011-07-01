Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1GAUkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 16:40:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39694 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752160Ab1GAUkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 16:40:05 -0400
Date: Fri, 1 Jul 2011 16:40:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: =?iso-8859-1?Q?=C9ric?= Piel <e.a.b.piel@tudelft.nl>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc5+ : khubd blocked
In-Reply-To: <20110701200800.GB17865@xanatos>
Message-ID: <Pine.LNX.4.44L0.1107011637091.1624-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011, Sarah Sharp wrote:

> On Fri, Jul 01, 2011 at 01:19:23PM -0400, Alan Stern wrote:
> > On Fri, 1 Jul 2011, [ISO-8859-1] ?ric Piel wrote:
> > 
> > > Sorry, but from a quick look, it seems to not fix the bug.
> > > 
> > > I'll try further on Monday.
> > 
> > Do you get a similar message from the task watchdog?  The patch should 
> > have caused usb_set_interface() to return early, without trying to 
> > acquire the mutex that caused the problem before.
> 
> I've been able to reproduce this bug with linus/master.  When I apply
> your patch (or at least change the code to match your patch, since I
> don't have those top-level directories),

What top-level directories?  You're not referring to the dummy 
"usb-3.0.orig" and "usb-3.0" path components in the patch?  They don't 
matter if you use "patch -p1".

>  I can successfully unplug and
> replug in a hub with a keyboard and mouse attached to it, with no hangs.
> So I'm not sure why it isn't working for Éric.
> 
> One further complication of the original patch is that when the xHCI
> driver is unloaded, usb_disable_device is called for devices under the
> USB 2.0 split rootub after the USB 3.0 roothub has been unregistered and
> the xHCI host is halted.  The configure endpoint code doesn't actually
> check if the hardware is running before submitting commands, so it takes
> about 30 seconds for the command for each device to timeout.  So that
> needs to be fixed as well.
> 
> Do you mind if I just take your patch and make a proper fix out of it?

Don't bother; I'll send it in to Greg momentarily (along with your 
Tested-by if you don't mind).

Alan Stern

