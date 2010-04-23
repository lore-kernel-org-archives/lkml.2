Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0DWPws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:52:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54809 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757773Ab0DWPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:52:27 -0400
Date: Fri, 23 Apr 2010 11:52:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USBIP (staging) driver's dependency on drivers/usb/core internal
 headers
In-Reply-To: <20100423150734.GA7778@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1004231140190.1777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Greg KH wrote:

> On Fri, Apr 23, 2010 at 12:44:11PM +0200, Eric Lescouet wrote:
> > Hi,
> >
> > The USBIP modules (and some others) have a direct dependency on the following headers:
> > - drivers/usb/core/hdc.h (struct usb_hcd and various routines)
> > - drivers/usb/core/hub.h (couple of constants)
> > Because those headers are not part of include/, it makes it quite difficult
> > to compile them as standalone modules (e.g.: against pre-compiled kernel).
> 
> Then don't do that :)
> 
> > hdc.c and hub.c are relatively self-contained and could be moved to e.g.: include/linux/usb/.
> >
> > What do you think?
> 
> I think the code needs to be cleaned up and merged to the main part of
> the kernel tree, then this wouldn't be an issue, right?

I think moving hub.h into include/linux/usb would be a good thing.  
However, if this is done then the file contents should be rearranged 
slightly:

	Everything from the "Hub request types" comment through the
	various HUB_TTTT_* definitions (except the line declaring
	struct usb_device) should be extracted into a separate file.
	This new file could be called ch11.h (because it contains 
	constants and structures from Chapter 11 of the USB 2.0 spec, 
	just as ch9.h contains information from Chapter 9) or it
	could keep the name hub.h.  It could even be exported as
	a userspace header file.

	The remainder (not very much) should be merged into hcd.h.

Once that's done, moving hcd.h into include/linux/usb would be a 
reasonable thing to do as well.  It is shared between usbcore and the 
HCDs, so it really does belong in a more public location.

Alan Stern

