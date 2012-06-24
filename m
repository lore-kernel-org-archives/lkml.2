Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2FXVtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 17:49:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47083 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2FXVtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 17:49:31 -0400
Message-ID: <4FE78B62.4090106@suse.cz>
Date: Sun, 24 Jun 2012 23:49:22 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120610 Thunderbird/15.0a2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 02/12] usb: fix sillies in the metro USB driver
References: <20120622153600.1405.15575.stgit@localhost.localdomain> <20120622153655.1405.21453.stgit@localhost.localdomain>
In-Reply-To: <20120622153655.1405.21453.stgit@localhost.localdomain>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 05:38 PM, Alan Cox wrote:
> Bits noticed doing the termios conversion
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/usb/serial/metro-usb.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/serial/metro-usb.c b/drivers/usb/serial/metro-usb.c
> index 81423f7..bad5f0c 100644
> --- a/drivers/usb/serial/metro-usb.c
> +++ b/drivers/usb/serial/metro-usb.c
> @@ -130,20 +130,14 @@ static void metrousb_read_int_callback(struct urb *urb)
...
>  	if (tty && urb->actual_length) {
>  		/* Loop through the data copying each byte to the tty layer. */
>  		tty_insert_flip_string(tty, data, urb->actual_length);
>  
>  		/* Force the data to the tty layer. */
>  		tty_flip_buffer_push(tty);
> +		tty_kref_put(tty);
>  	}
> -	tty_kref_put(tty);

This doesn't seem right. (Depends on whether tty is non-null iff
urb->actual_length is non-zero.)

thanks,
-- 
js
suse labs
