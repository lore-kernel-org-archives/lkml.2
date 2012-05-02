Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2EBVwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:52:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61249 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2EBVwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:52:30 -0400
Date: Wed, 2 May 2012 14:52:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Preston Fick <pffick@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com
Subject: Re: [PATCH 3/3] usb: cp210x: Add ioctl for GPIO support
Message-ID: <20120502215226.GD27281@kroah.com>
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
 <1335845210-5147-3-git-send-email-preston.fick@silabs.com>
 <20120502200356.GA25915@kroah.com>
 <20120502214901.6b6e031c@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502214901.6b6e031c@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 09:49:01PM +0100, Alan Cox wrote:
> > Actually, why can't you use the GPIO subsystem for something like this?
> > Can't you export your device as both a usb-serial device and a gpio
> > device and have things work properly that way?
> 
> You still need the ioctls even then in order to discover the gpio
> numbers

What discovery?  The device knows what gpio values it has in it, and
should be able to register those with the gpio subsystem.

> and having done that youi've got potential races with unload
> when you try and open them. You've also got permissions considerations
> and synchronization between gpio and data problems.

That can be handled in the driver itself, if it really is a problem (the
existing patch sure didn't handle any of that at all, so I'm guessing
either it wasn't considered, or it isn't a problem.)

> It's not a good way to go. It might make sense in some platforms to
> expose them as both but its not a good general model.

Why isn't the gpio subsystem a good general model?  I thought that is
what it was created to solve?

> I'm currently favouring adding some 'additional control line' bits to
> termiox.

Yes, but that's only good for usb-serial devices that also have gpio
pins on the controller side.  Which seems pretty limited to me.

If I have a userspace program, and I want to use GPIO, I shouldn't have
to care/know that the pins are really on the end of a USB->serial
bridge, or somewhere hanging off of a SOC, the same userspace api should
"just work", right?

Or am I missing something really obvious here?

thanks,

greg k-h
