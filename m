Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0DWQiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:38:18 -0400
Received: from kroah.org ([198.145.64.141]:49974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104Ab0DWQiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:38:13 -0400
Date: Fri, 23 Apr 2010 09:37:36 -0700
From: Greg KH <greg@kroah.com>
To: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: USBIP (staging) driver's dependency on drivers/usb/core
 internal headers
Message-ID: <20100423163736.GA5980@kroah.com>
References: <20100423150734.GA7778@kroah.com>
 <Pine.LNX.4.44L0.1004231140190.1777-100000@iolanthe.rowland.org>
 <20100423161455.GA21129@kroah.com>
 <4BD1CB60.20209@VirtualLogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD1CB60.20209@VirtualLogix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 06:31:28PM +0200, Eric Lescouet wrote:
> Greg KH wrote:
> >On Fri, Apr 23, 2010 at 11:52:26AM -0400, Alan Stern wrote:
> >>On Fri, 23 Apr 2010, Greg KH wrote:
> >>
> >>>On Fri, Apr 23, 2010 at 12:44:11PM +0200, Eric Lescouet wrote:
> >>>>Hi,
> >>>>
> >>>>The USBIP modules (and some others) have a direct dependency on the following headers:
> >>>>- drivers/usb/core/hdc.h (struct usb_hcd and various routines)
> >>>>- drivers/usb/core/hub.h (couple of constants)
> >>>>Because those headers are not part of include/, it makes it quite difficult
> >>>>to compile them as standalone modules (e.g.: against pre-compiled kernel).
> >>>Then don't do that :)
> >>>
> >>>>hdc.c and hub.c are relatively self-contained and could be moved to e.g.: include/linux/usb/.
> >>>>
> >>>>What do you think?
> >>>I think the code needs to be cleaned up and merged to the main part of
> >>>the kernel tree, then this wouldn't be an issue, right?
> >>I think moving hub.h into include/linux/usb would be a good
> >>thing.  However, if this is done then the file contents should
> >>be rearranged slightly:
> >>
> >>	Everything from the "Hub request types" comment through the
> >>	various HUB_TTTT_* definitions (except the line declaring
> >>	struct usb_device) should be extracted into a separate file.
> >>	This new file could be called ch11.h (because it contains
> >>	constants and structures from Chapter 11 of the USB 2.0 spec,
> >>	just as ch9.h contains information from Chapter 9) or it
> >>	could keep the name hub.h.  It could even be exported as
> >>	a userspace header file.
> >>
> >>	The remainder (not very much) should be merged into hcd.h.
> >>
> >>Once that's done, moving hcd.h into include/linux/usb would be a
> >>reasonable thing to do as well.  It is shared between usbcore
> >>and the HCDs, so it really does belong in a more public
> >>location.
> >
> >Ok, fair enough.  Patches are always welcome :)
> >
> >thanks,
> >
> >greg k-h
> 
> If I understand correctly, splitting hub.h into hub.h + ch11.h is
> independent of the move. At the end the 2 (or 3 files) would end up
> into include/linux/usb/.
> correct?
> 
> I've tried to move hub.h and hcd.h and to compile the kernel, already.
> Changing the path of the #include directives in ~40 files did the trick.

40 files need to be changed?  wow.

> Would you like 2 patches (move and then split) or only 1?

Move and then split is fine.

thanks,

greg k-h
