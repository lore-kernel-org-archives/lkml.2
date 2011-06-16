Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab1FPPUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:20:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40340 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757009Ab1FPPUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:20:45 -0400
Date: Thu, 16 Jun 2011 11:20:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, Amit Blay <ablay@qualcomm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to
 devio.c
In-Reply-To: <1308231068-24038-6-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1106161118270.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Tatyana Brokhman wrote:

> Allow user space applications such as LIBUSB, to request
> streams alloc/dealloc from HCD that implements XHCI.
> 
> Signed-off-by: Amit Blay <ablay@qualcomm.com>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

...

> diff --git a/include/linux/usbdevice_fs.h b/include/linux/usbdevice_fs.h
> index 15591d2..133c216 100644
> --- a/include/linux/usbdevice_fs.h
> +++ b/include/linux/usbdevice_fs.h
> @@ -108,6 +108,7 @@ struct usbdevfs_urb {
>  				  or 0 if none should be sent. */
>  	void __user *usercontext;
>  	struct usbdevfs_iso_packet_desc iso_frame_desc[0];
> +	unsigned int stream_id;
>  };
>  
>  /* ioctls for talking directly to drivers */
> @@ -165,6 +166,7 @@ struct usbdevfs_urb32 {
>  	compat_uint_t signr;
>  	compat_caddr_t usercontext; /* unused */
>  	struct usbdevfs_iso_packet_desc iso_frame_desc[0];
> +	compat_uint_t stream_id;
>  };

It would be nice if we could do this, but we can't.  We are not allowed 
to change an established ABI.  Every copy of libusb would have to be 
rebuilt.

Alan Stern

