Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3AJPNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:13:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58912 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753210Ab3AJPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:13:19 -0500
Date: Thu, 10 Jan 2013 10:13:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Josh Boyer <jwboyer@redhat.com>, <gregkh@linuxfoundation.org>,
        <mdharm-usb@one-eyed-alien.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: USB autosuspend vs. URB submission
In-Reply-To: <2664900.viczl5BYBS@avalon>
Message-ID: <Pine.LNX.4.44L0.1301101009240.1178-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013, Laurent Pinchart wrote:

> Hi Josh,
> 
> On Tuesday 08 January 2013 11:03:22 Josh Boyer wrote:
> > On Tue, Jan 08, 2013 at 10:51:20AM -0500, Alan Stern wrote:
> > > On Mon, 7 Jan 2013, Josh Boyer wrote:
> > > > Hi,
> > > > 
> > > > We've had a few reports in Fedora of users hitting the WARN_ONCE in
> > > > drivers/usb/core/urb.c that prints a warning about a usb_submit_urb
> > > > being called on an active URB.  One of them[1] is from the ums_realtek
> > > > driver and the other[2] is from the uvcvideo driver.  However, I noticed
> > > > that in both instances it seems the devices were coming back from what I
> > > > think is autosuspend.
> > > > 
> > > > I didn't immediately find any similar reports, and to my rather
> > > > inexperienced eyes the drivers didn't seem to be doing anything clearly
> > > > wrong.  I'm wondering if anyone has some possible ideas for debugging
> > > > and whether or not this might be a general issue?
> > > 
> > > I don't see anything wrong either.
> > > 
> > > Can you ask the users to collect a usbmon trace covering the period
> > > when the problem occurs?
> > 
> > I'll certainly ask. I'm not particularly hopeful for great results though,
> > as the problems seem to be rather intermittent.
> > 
> > Thanks for taking a look.
> 
> I've never heard of such problems with the uvcvideo driver, and I don't see 

Such problems could have existed silently.  The new kernel calls 
WARN_ONCE but otherwise treats the error the same as the old kernels.

> anything wrong with the code at first sight. The driver only submits URBs when 
> starting the video capture (at that point no URB should be in flight) or in 
> the URB completion handler (by definition the URB has completed then).
> 
> I've had a quick look at the trace posted at 
> https://bugzilla.redhat.com/show_bug.cgi?id=879462 but usbmon only shows URBs 
> that are successfully submitted. I'm not sure what useful information I could 
> get from the trace.

As Ming Lei pointed out, we would have to combine the dmesg information 
with the usbmon trace.  The WARN_ONCE and usbmon both provide the URB's 
address, so we could tell if that URB really was still pending when the 
WARN_ONCE was triggered.  We also might be able to tell (by looking at 
the URB's contents) what piece of code had submitted it the first time.

Alan Stern

