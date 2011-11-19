Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab1KSVC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 16:02:26 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49069 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753438Ab1KSVCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 16:02:25 -0500
Date: Sat, 19 Nov 2011 16:02:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Nazarewicz <mpn@google.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Felipe Balbi <balbi@ti.com>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Anatolij Gustschin <agust@denx.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ben Dooks <ben@simtec.co.uk>, Heiko Stubner <heiko@sntech.de>,
        Thomas Abraham <thomas.ab@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: udc: Fix gadget driver's speed check in various
 UDC drivers
In-Reply-To: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1111191559240.6165-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> Several UDC drivers had a gadget driver's speed sanity check of the
> form of:
> 
> 	driver->speed != USB_SPEED_HIGH
> 
> or:
> 
> 	driver->speed != USB_SPEED_HIGH && driver->speed != USB_SPEED_FULL
> 
> As more and more gadget drivers support USB SuperSpeed, driver->speed
> may be set to USB_SPEED_SUPER and UDC driver should handle such gadget
> correctly.  The above checks however fail to recognise USB_SPEED_SUPER
> as a valid speed.
> 
> This commit changes the two checks to:
> 
> 	driver->speed < USB_SPEED_HIGH
> 
> or:
> 
> 	driver->speed < USB_SPEED_FULL
> 
> respectively.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Reported-by: Alan Stern <stern@rowland.harvard.edu>
> ---
> 
> I had no way of testing those changes but it appears that those UDC
> drivers check gadget driver's speed only on the entry point and then
> nothing is really dependent on it.

That's right; the idea is merely to avoid connecting at a speed that's
too fast for the gadget driver to handle.

> The only thing that makes me wonder a little is that
> USB_SPEED_WIRELESS will be allowed by the above checks and I'm not
> entirely sure if that's desired (even though that's probably not an
> issue right now).

I agree, wireless will eventually pose a problem.  Let's not worry 
about it for now, though.

> Nonetheless, this patch needs to get merged to 3.2 as without it
> file_storage won't work on UDC drivers this patch updates.
> 
> The next two patches that follow this one are replacements for
> [291a72f8: usb: gadget: replace usb_gadget::is_dualspeed with
> max_speed] and [d93bb846: usb: gadget: rename usb_gadget_driver::speed
> to max_speed] from Felipe's gadget tree, which did not apply correctly
> on top of this patch.

This all looks very good.  Thanks for doing the work.

Alan Stern

