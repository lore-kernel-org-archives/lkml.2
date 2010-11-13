Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab0KMAbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 19:31:18 -0500
Received: from netrider.rowland.org ([192.131.102.5]:59361 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757644Ab0KMAbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 19:31:16 -0500
Date: Fri, 12 Nov 2010 19:31:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefan Achatz <erazor_de@users.sourceforge.net>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: HID: questions about polling rates
In-Reply-To: <1289589352.2629.95.camel@neuromancer>
Message-ID: <Pine.LNX.4.44L0.1011121921190.25162-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, Stefan Achatz wrote:

> Hello,
> 
> while working on my roccat device drivers I thought about the possiblity
> of on the fly polling rate changes and tested some things.
> 
> First I tried different polling rates by writing values from 1 to 10
> into /sys/bus/usb/drivers/usbhid/module/parameters/mousepoll. I
> observed that the polling rates seem to be capped on both sides. With
> value 1 I measure 2ms instead of 1ms with my hardware protocol
> analyzer. With 10 I get 8ms instead of 10ms.

What type of USB host controller are you using?

The existing drivers (at least, the ones I'm aware of) will only poll
at intervals that are powers of 2.  They won't poll at intervals of 10
ms, for example; the value gets rounded down to 8 ms.  But you should 
be able to poll at intervals of 16 or 32 ms if you want.

There's no reason I know of why you shouldn't be able to poll at 1-ms
intervals.

>  I only use cheap onboard
> usb controllers, but under windows they work with 1ms. A internet and
> code search revealed nothing regarding this to me. Is someone of you
> aware of this behaviour and could tell me more about it?

Note that according to the USB spec, low-speed devices like mice are 
not allowed to request polling intervals shorter than 10 ms.  Of course 
this doesn't matter to you, because you are overriding the device's 
built-in settings.

> Changing the polling rate of a device on the fly would requires to
> use usb_kill_urb() and usb_submit_urb() with new interval. To get the
> int_urb I would need additional informations for incomplete struct
> usbhid_device that lie in drivers/hid/usbhid/usbhid.h. My driver code
> is at home in drivers/hid/. Is it okay to include a header further
> down in the structure? Or does anyone have concerns about moving the
> mentioned header to include/linux? Is this a matter to follow at all?

You can include any header you like in your driver, regardless of where
it lives.  Why do you want to change the polling rate on the fly?

Alan Stern

