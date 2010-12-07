Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0LGWk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:40:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0LGWk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:40:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=uy7NpTyuwK27gZlTrhzNWDG86kTRIaM2uOj3SSqRQsiensET+V4ykC4UCSO9wjYh62
         ydUQcJsqz5V1xrPtTlANHWEjONsYtu2MTIdN8NLky0XmUAJh2RxchvLg2lUOjTJOPKjn
         IMmif91edZV0EDTnwb4ajSuM0+dAJVYDuAHGY=
Date: Wed, 8 Dec 2010 01:40:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/udlfb: Fix sparse warning 'Using plain integer
 as NULL pointer'
Message-ID: <20101207224039.GP10623@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1291760201-18531-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291760201-18531-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 11:16:41PM +0100, Peter Huewe wrote:
>  	while ((pixel_end > pixel) &&
>  	       (cmd_buffer_end - MIN_RLX_CMD_BYTES > cmd)) {
> -		uint8_t *raw_pixels_count_byte = 0;
> -		uint8_t *cmd_pixels_count_byte = 0;
> -		const uint16_t *raw_pixel_start = 0;
> -		const uint16_t *cmd_pixel_start, *cmd_pixel_end = 0;
> +		uint8_t *raw_pixels_count_byte = NULL;
> +		uint8_t *cmd_pixels_count_byte = NULL;
> +		const uint16_t *raw_pixel_start = NULL;
> +		const uint16_t *cmd_pixel_start, *cmd_pixel_end = NULL;
>  

It would be better to delete these.  The assignments are pointless and
may well end up generating warnings in future versions of gcc.  (Maybe
it already does with beta versions of gcc?)

> -		struct fb_videomode fb_vmode = {0};
> +		struct fb_videomode fb_vmode = {NULL};

Just do this:
		struct fb_videomode fb_vmode = {};

>  	struct usb_device *usbdev;
> -	struct dlfb_data *dev = 0;
> -	struct fb_info *info = 0;
> +	struct dlfb_data *dev = NULL;
> +	struct fb_info *info = NULL;
>  	int retval = -ENOMEM;
>  	int i;

You could leave dev uninitialized here again.

regards,
dan carpenter
