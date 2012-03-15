Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032254Ab2COUDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:03:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47803 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1032233Ab2COUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:03:03 -0400
Date: Thu, 15 Mar 2012 16:03:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
cc: Pete Zaitcev <zaitcev@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/ub: deprecate & schedule for removal the "Low
 Performance USB Block" driver
In-Reply-To: <20120315175701.GA5702@breakpoint.cc>
Message-ID: <Pine.LNX.4.44L0.1203151601070.1366-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Sebastian Andrzej Siewior wrote:

> On Thu, Mar 15, 2012 at 09:33:31AM -0600, Pete Zaitcev wrote:
> > On Wed, 14 Mar 2012 21:52:51 +0100
> > Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:
> > 
> > > +What:	Low Performance USB Block driver ("CONFIG_BLK_DEV_UB")
> > > +When:	3.6
> > 
> > ACK
> > 
> > > +	does not use libusual which holds various workarounds for
> > > +	certain buggy devices.
> > 
> > Although the above is false, and ub actually started libusual,
> > I don't mind. It's a transient notice anyway. Once ub is gone,
> > libusual can be folded back into usb-storage.
> 
> There might be an miss understanding here. For instance in
> drivers/usb/storage/unusual_devs.h we have an entry like:
> 
> |UNUSUAL_DEV(  0x03f0, 0x4002, 0x0001, 0x0001,
> |                 "HP",
> |                 "PhotoSmart R707",
> |                 USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_FIX_CAPACITY),
> |
> 
> That US_FL_FIX_CAPACITY is used later in scsiglue.c to set sdev->fix_capacity
> which is then used by sd_read_capacity() to substract one sector from the
> final size.
> In ub I see ub_sync_read_cap() and I don't see a change. Was my wording wrong
> or is this something else?

Pete wasn't talking about the phrase "holds various workarounds...".  
Rather, he was referring to the phrase "does not use libusual".  That
part is wrong; ub _does_ use libusual.

Alan Stern

