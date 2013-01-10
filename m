Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3AJPUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:20:44 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58928 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753761Ab3AJPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:20:43 -0500
Date: Thu, 10 Jan 2013 10:20:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Josh Boyer <jwboyer@redhat.com>, <gregkh@linuxfoundation.org>,
        <mdharm-usb@one-eyed-alien.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: USB autosuspend vs. URB submission
In-Reply-To: <1643419.R9VmOAX4j3@linux-5eaq.site>
Message-ID: <Pine.LNX.4.44L0.1301101015530.1178-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013, Oliver Neukum wrote:

> On Thursday 10 January 2013 00:05:55 Laurent Pinchart wrote:
> 
> > I've had a quick look at the trace posted at 
> > https://bugzilla.redhat.com/show_bug.cgi?id=879462 but usbmon only shows URBs 
> > that are successfully submitted. I'm not sure what useful information I could 
> > get from the trace.
> 
> The test is at the very start of usb_submit_urb()
> 
>         if (!urb || !urb->complete)
>                 return -EINVAL;
>         if (urb->hcpriv) { 
>                 WARN_ONCE(1, "URB %p submitted while active\n", urb);
>                 return -EBUSY;
>         }
> 
> usbmon will never see such URBs

Not quite -- it will see them the first time they are submitted, when
the submission succeeds.

> I suggest that for debugging you change the WARN_ONCE into a WARN and compare
> the URB pointers of usbmon and dmesg.

Good idea.

> In the long run it is probably a good idea to pass duplicated URBs to usbmon by
> a special code path.

I'd prefer to add extra information to the WARN_ONCE message.  Even 
though it would require the extra effort of correlating the dmesg 
output with the usbmon output.

You know, it's possible that the URB really was not submitted before 
but instead the urb->hcpriv field got overwritten.  Of course, that 
would also be a bug.

Alan Stern

