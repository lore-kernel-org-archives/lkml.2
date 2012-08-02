Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab2HBOsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:48:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59500 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752664Ab2HBOs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:48:28 -0400
Date: Thu, 2 Aug 2012 10:48:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <praveen.nadahally@stericsson.com>
Subject: Re: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
In-Reply-To: <1343889402-7826-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
Message-ID: <Pine.LNX.4.44L0.1208021046280.1285-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2012, Virupax Sadashivpetimath wrote:

> In case of USB bulk transfer, when himem page
> is received, the usb_sg_init function sets the
> urb transfer buffer to NULL. When such URB
> transfer is handled, kernel crashes in PIO mode.
> Handle this by mapping the highmem buffer in PIO mode.


> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -21,6 +21,7 @@
>  #include <linux/sched.h>	/* for current && schedule_timeout */
>  #include <linux/mutex.h>	/* for struct mutex */
>  #include <linux/pm_runtime.h>	/* for runtime PM */
> +#include <linux/scatterlist.h>
>  
>  struct usb_device;
>  struct usb_driver;
> @@ -1309,6 +1310,7 @@ struct urb {
>  	usb_complete_t complete;	/* (in) completion routine */
>  	struct usb_iso_packet_descriptor iso_frame_desc[0];
>  					/* (in) ISO ONLY */
> +	struct sg_mapping_iter sg_miter; /* handling highmem data in PIO mode */
>  };

This is unacceptable.  Fields like this should be stored in the 
URB's hcpriv structure, not in the URB itself.

Alan Stern

