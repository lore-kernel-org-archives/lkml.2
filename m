Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab1JQSWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:22:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58999 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752179Ab1JQSWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:22:54 -0400
Date: Mon, 17 Oct 2011 14:22:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <20111017181117.GA17422@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1110171419550.1749-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Johannes Stezenbach wrote:

> On Sat, Oct 15, 2011 at 03:04:28PM -0400, Alan Stern wrote:
> > On Sat, 15 Oct 2011, Johannes Stezenbach wrote:
> > 
> > >  It would make a difference if the
> > > device violated the spec and sent 188 byte packets. However, the
> > > spec says a short packet terminates the transfer.  But I wonder
> > > if this is really the case?
> > 
> > The device does not send short packets.  If it did, the 24064-byte 
> > transfers would end early.
> 
> Re-reading the USB-2.0 standard, a short packet which terminates
> the transfer is defined by packet_size < wMaxPacketSize,
> not by packet_size < 512.
> Thus wMaxPacketSize == 188 (or 2*188) might be possible.
> 
> There is a comment in linux/drivers/usb/host/ehci-q.c:
> 
> 	/* The USB spec says that high speed bulk endpoints
> 	 * always use 512 byte maxpacket.  But some device
> 	 * vendors decided to ignore that, and MSFT is happy
> 	 * to help them do so.  So now people expect to use
> 	 * such nonconformant devices with Linux too; sigh.
> 	 */

That comment referred to devices with wMaxPacketSize = 1024, which has
been seen in the wild.  But other bizarre sizes are possible.

> Maybe we should look at the descriptors?

It won't hurt, although I would be quite surprised to see anything
other than 512.

Markus, can you post the output from "lsusb -v" for this inflexible 
webcam?

Alan Stern

