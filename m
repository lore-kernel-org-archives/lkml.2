Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2CTN6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:58:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49898 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2CTN6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:58:51 -0400
Date: Tue, 20 Mar 2012 06:58:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Darryl <ddegraff@licor.com>
Cc: prakash.pm@ti.com, sshtylyov@mvista.com,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: arm: davinci: USB ethernet
Message-ID: <20120320135847.GB4634@kroah.com>
References: <4F670E6A.9060403@licor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F670E6A.9060403@licor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 05:46:02AM -0500, Darryl wrote:
> We are currently using a DA850 eval board but will eventually use a
> custom board to interface host system to davinci using ethernet over
> USB.  We are using 2.6.37 with real-time patches, but a cursory look
> (have not been able to build yet) at 3.3-rc7 suggests that the
> issues noted below still exist.
> 
> There are currently two issues:
> 
> - Documentation/usb/hotplug.txt suggests that the drivers should be
> built as modules so that such things as loading drivers and, in this
> case, bringing up the interface, can ge moderated in user-space.
> However, though the code can be build modular, the drivers are never
> loaded.  I suspect that one or more of the several relevant configs
> (I see at least these:  USB_MUSB_HDRC, USB_MUSB_DA8XX_GLUE,
> USB_GADGET, USB_ETH, USB_GPIO_VBUS, NOP_USB_XCEIV, USB_ETH_RNDIS,
> USB_OTG_UTILS) are required to be built in, but cannot seem to
> determine the correct ones.

Do you have a userspace tool that will automatically load the proper
modules when they show up?

As for unwinding the .config issues, you will have to do this, based on
your own settings, not much we can do here.

> - Even when compiling all the driver code built-in, neither the
> plug-in nor plug-out event is propagated to user space, again, so
> that the interface can be brought up.

How do you know it isn't showing up?  What are you using to watch for
it?  Are you using udev?  Something else?  devtmpfs?

greg k-h
