Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1DRAyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 20:54:23 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:43779 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1DRAyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 20:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=v3FFVM5A1oQcB+fE4i0jrXcHg5EIYa0fY4O7gMKBJb0LxFrYiYNH7eEMpu2vQ7vLCY
         ZTdvJQ017BGjzQvTlUKd1Cff0XjAMd6m1Fx5LulzlPa4+lkwR0UM7+6LwvACJMe5/MQc
         UnPoTsVHKEoh5SvdNbKQ6kEI7BAV8KiG/i6/w=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <014287655bd0c4327bbd946b9c823a0e4ec35f8e.1303079016.git.tfransosi@gmail.com>
References: <014287655bd0c4327bbd946b9c823a0e4ec35f8e.1303079016.git.tfransosi@gmail.com>
Date: Mon, 18 Apr 2011 08:54:16 +0800
X-Google-Sender-Auth: _lsh7ReZt7S6C_i2DXXXPdv_jFU
Message-ID: <BANLkTikDtpg2CKM_Rq9hZ44F4jHvM3bOdg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers/usb/image/mdc800.c: Remove "typdef enum".
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/11, Thiago Farina <tfransosi@gmail.com> wrote:
> Instead use the keyword "enum" where we use it.
>
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/usb/image/mdc800.c |  111
> +++++++++++++++++++++----------------------
>  1 files changed, 54 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
> index 575b56c..4b0a032 100644
> --- a/drivers/usb/image/mdc800.c
> +++ b/drivers/usb/image/mdc800.c
> @@ -122,59 +122,57 @@
>  /* Minor Number of the device (create with mknod /dev/mustek c 180 32) */
>  #define MDC800_DEVICE_MINOR_BASE 32
>
> +/*
> + * Data and structs.
> + */
>
> -/**************************************************************************
> -	Data and structs
> -***************************************************************************/
> -
> -
> -typedef enum {
> +enum mdc800_state {
>  	NOT_CONNECTED, READY, WORKING, DOWNLOAD
> -} mdc800_state;
> +};
>
>
> -/* Data for the driver */
> +/* Data for the driver. */
>  struct mdc800_data
>  {
> -	struct usb_device *	dev;			// Device Data
> -	mdc800_state 		state;
> +	struct usb_device*      dev;                  /* Device Data. */
> +	enum mdc800_state	state;
>
> -	unsigned int		endpoint [4];
> +	unsigned int		endpoint[4];
>
> -	struct urb *		irq_urb;
> +	struct urb*             irq_urb;
>  	wait_queue_head_t	irq_wait;
>  	int			irq_woken;
>  	char*			irq_urb_buffer;
>
> -	int			camera_busy;          // is camera busy ?
> -	int 			camera_request_ready; // Status to synchronize with irq
> -	char 			camera_response [8];  // last Bytes send after busy
> +	int			camera_busy;          /* Is camera busy? */
> +	int			camera_request_ready; /* Status to synchronize with irq. */
> +	char			camera_response[8];   /* last Bytes send after busy. */
>
> -	struct urb *   		write_urb;
> +	struct urb*             write_urb;
>  	char*			write_urb_buffer;
>  	wait_queue_head_t	write_wait;
>  	int			written;
>
>
> -	struct urb *   		download_urb;
> +	struct urb*		download_urb;
>  	char*			download_urb_buffer;
>  	wait_queue_head_t	download_wait;
>  	int			downloaded;
> -	int			download_left;		// Bytes left to download ?
> +	int			download_left;       /* Bytes left to download? */
>
>
>  	/* Device Data */
> -	char			out [64];	// Answer Buffer
> -	int 			out_ptr;	// Index to the first not readen byte
> -	int			out_count;	// Bytes in the buffer
> +	char			out[64];	/* Answer buffer. */
> +	int			out_ptr;	/* Index to the first not readen byte. */
> +	int			out_count;	/* Bytes in the buffer. */
>
> -	int			open;		// Camera device open ?
> -	struct mutex		io_lock;	// IO -lock
> +	int			open;		/* Camera device open. */
> +	struct mutex		io_lock;	/* IO -lock. */
>
> -	char 			in [8];		// Command Input Buffer
> -	int  			in_count;
> +	char			in [8];		/* Command Input Buffer. */
> +	int			in_count;
>
> -	int			pic_index;	// Cache for the Imagesize (-1 for nothing cached )
> +	int			pic_index;	/* Cache for the Imagesize (-1 for nothing cached) */
>  	int			pic_len;
>  	int			minor;
>  };
> @@ -183,52 +181,51 @@ struct mdc800_data
>  /* Specification of the Endpoints */
>  static struct usb_endpoint_descriptor mdc800_ed [4] =
>  {
> -	{
> -		.bLength = 		0,
> +	{
> +		.bLength =		0,
>  		.bDescriptorType =	0,
>  		.bEndpointAddress =	0x01,
> -		.bmAttributes = 	0x02,
> +		.bmAttributes =         0x02,
>  		.wMaxPacketSize =	cpu_to_le16(8),
> -		.bInterval = 		0,
> -		.bRefresh = 		0,
> -		.bSynchAddress = 	0,
> +		.bInterval =		0,
> +		.bRefresh =		0,
> +		.bSynchAddress =	0,
>  	},
>  	{
> -		.bLength = 		0,
> -		.bDescriptorType = 	0,
> -		.bEndpointAddress = 	0x82,
> -		.bmAttributes = 	0x03,
> -		.wMaxPacketSize = 	cpu_to_le16(8),
> -		.bInterval = 		0,
> -		.bRefresh = 		0,
> -		.bSynchAddress = 	0,
> +		.bLength =		0,
> +		.bDescriptorType =	0,
> +		.bEndpointAddress =	0x82,
> +		.bmAttributes =         0x03,
> +		.wMaxPacketSize =	cpu_to_le16(8),
> +		.bInterval =		0,
> +		.bRefresh =		0,
> +		.bSynchAddress =	0,
>  	},
>  	{
> -		.bLength = 		0,
> -		.bDescriptorType = 	0,
> -		.bEndpointAddress = 	0x03,
> -		.bmAttributes = 	0x02,
> -		.wMaxPacketSize = 	cpu_to_le16(64),
> -		.bInterval = 		0,
> -		.bRefresh = 		0,
> -		.bSynchAddress = 	0,
> +		.bLength =		0,
> +		.bDescriptorType =	0,
> +		.bEndpointAddress =	0x03,
> +		.bmAttributes =         0x02,
> +		.wMaxPacketSize =	cpu_to_le16(64),
> +		.bInterval =		0,
> +		.bRefresh =		0,
> +		.bSynchAddress =	0,
>  	},
>  	{
> -		.bLength = 		0,
> -		.bDescriptorType = 	0,
> -		.bEndpointAddress = 	0x84,
> -		.bmAttributes = 	0x02,
> -		.wMaxPacketSize = 	cpu_to_le16(64),
> -		.bInterval = 		0,
> -		.bRefresh = 		0,
> -		.bSynchAddress = 	0,
> +		.bLength =		0,
> +		.bDescriptorType =	0,
> +		.bEndpointAddress =     0x84,
> +		.bmAttributes =         0x02,
> +		.wMaxPacketSize =	cpu_to_le16(64),
> +		.bInterval =		0,
> +		.bRefresh =		0,
> +		.bSynchAddress =	0,
>  	},
>  };
>
>  /* The Variable used by the driver */
>  static struct mdc800_data* mdc800;
>
> -
> /***************************************************************************
>  	The USB Part of the driver
> ****************************************************************************/
> --
> 1.7.3.2.343.g7d43d
>
Why did you change it ? and why change so many lines ?
It had some thing wrong ?
Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
