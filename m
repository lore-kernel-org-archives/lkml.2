Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292Ab2CTQA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:00:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63820 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2CTQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:00:27 -0400
Date: Tue, 20 Mar 2012 09:00:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: ddegraff <ddegraff@neb.rr.com>
Cc: prakash.pm@ti.com, sshtylyov@mvista.com,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: arm: davinci: USB ethernet
Message-ID: <20120320160015.GA5930@kroah.com>
References: <4F670E6A.9060403@licor.com>
 <20120320135847.GB4634@kroah.com>
 <4F68A7C6.9040909@neb.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F68A7C6.9040909@neb.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 10:52:38AM -0500, ddegraff wrote:
> 
> 
> On 03/20/2012 08:58 AM, Greg KH wrote:
> >On Mon, Mar 19, 2012 at 05:46:02AM -0500, Darryl wrote:
> >>We are currently using a DA850 eval board but will eventually use a
> >>custom board to interface host system to davinci using ethernet over
> >>USB.  We are using 2.6.37 with real-time patches, but a cursory look
> >>(have not been able to build yet) at 3.3-rc7 suggests that the
> >>issues noted below still exist.
> >>
> >>There are currently two issues:
> >>
> >>- Documentation/usb/hotplug.txt suggests that the drivers should be
> >>built as modules so that such things as loading drivers and, in this
> >>case, bringing up the interface, can ge moderated in user-space.
> >>However, though the code can be build modular, the drivers are never
> >>loaded.  I suspect that one or more of the several relevant configs
> >>(I see at least these:  USB_MUSB_HDRC, USB_MUSB_DA8XX_GLUE,
> >>USB_GADGET, USB_ETH, USB_GPIO_VBUS, NOP_USB_XCEIV, USB_ETH_RNDIS,
> >>USB_OTG_UTILS) are required to be built in, but cannot seem to
> >>determine the correct ones.
> >Do you have a userspace tool that will automatically load the proper
> >modules when they show up?
> Busybox's mdev is currently intended for that.  I've used udev for
> other projects, but we have a very limited space here.

udev really is too big?  My cheap wireless router runs udev, I'm amazed
that people really feel that mdev is a proper replacement.

Odds are, you really don't need mdev, just use devtmpfs and be done with
it.

Anyway, as you are stuck with an old kernel release, I suggest you get
support from your vendor, they are the only ones that can help you out
here.

best of luck,

greg k-h
