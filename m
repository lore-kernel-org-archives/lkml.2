Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab1GLAuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:50:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58631 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755054Ab1GLAui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:50:38 -0400
Date: Mon, 11 Jul 2011 20:50:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jesper Juhl <jj@chaosbits.net>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] USB: Avoid NULL pointer dereference in usb_disconnect()
In-Reply-To: <alpine.LNX.2.00.1107112246220.10944@swampdragon.chaosbits.net>
Message-ID: <Pine.LNX.4.44L0.1107112049580.17690-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Jesper Juhl wrote:

> > This is okay, but it might be better just to remove the NULL test 
> > entirely.  Code inspection easily shows that it can never be triggered.
> > 
> I must admit I don't care much one way or the other. Moving the 
> dereference seemed like the best thing to do to me - defensive in the 
> face of future changes + anything that I possibly overlooked that could 
> cause the pointer to actually be NULL. 
> But I'm just as fine with just removing the NULL test and associated debug 
> print if that seems the best solution to others.
> 
> Here's a patch to remove the test. Now you have both, pick whichever you 
> prefer :-)

Given a choice, I prefer this one.  :-)

> From: Jesper Juhl <jj@chaosbits.net>
> Subject: [PATCH] USB: Remove test for NULL that'll never happen in usb_disconnect()
> 
> In drivers/usb/core/hub.c::usb_disconnect(), 'udev' will never be
> NULL, so remove the test and printing of debug message.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/usb/core/hub.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index a428aa0..99fff6b 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1636,11 +1636,6 @@ void usb_disconnect(struct usb_device **pdev)
>  	int			i;
>  	struct usb_hcd		*hcd = bus_to_hcd(udev->bus);
>  
> -	if (!udev) {
> -		pr_debug ("%s nodev\n", __func__);
> -		return;
> -	}
> -
>  	/* mark the device as inactive, so any further urb submissions for
>  	 * this device (and any of its children) will fail immediately.
>  	 * this quiesces everything except pending urbs.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

