Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2K3CKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:10:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35116 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K3CKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:10:30 -0500
Date: Thu, 29 Nov 2012 18:10:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging/serqt_usb2: Refactor qt_status_change_check() in
 serqt_usb2.c
Message-ID: <20121130021026.GB2056@kroah.com>
References: <1354165076-30273-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354165076-30273-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:57:56PM +0900, YAMANE Toshiaki wrote:
> Improved position to increment variable i,
> And typo fixes.
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/serqt_usb2/serqt_usb2.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
> index 1b3e995..095d6f2 100644
> --- a/drivers/staging/serqt_usb2/serqt_usb2.c
> +++ b/drivers/staging/serqt_usb2/serqt_usb2.c
> @@ -309,26 +309,26 @@ static void qt_status_change_check(struct tty_struct *tty,
>  			case 0x00:
>  				if (i > (RxCount - 4)) {
>  					dev_dbg(&port->dev,
> -						"Illegal escape seuences in received data\n");
> +						"Illegal escape sequence in received data\n");

This is a different type of fix from:

>  					break;
>  				}
>  
> -				ProcessLineStatus(qt_port, data[i + 3]);
> -
>  				i += 3;
> +				ProcessLineStatus(qt_port, data[i]);

I think you just changed the logic in this function, didn't you?

> +
>  				flag = 1;
>  				break;
>  
>  			case 0x01:
>  				if (i > (RxCount - 4)) {
>  					dev_dbg(&port->dev,
> -						"Illegal escape seuences in received data\n");
> +						"Illegal escape sequence in received data\n");
>  					break;
>  				}
>  
> -				ProcessModemStatus(qt_port, data[i + 3]);
> -
>  				i += 3;
> +				ProcessModemStatus(qt_port, data[i]);

Same here, what happens to i after this?

Please break into two patches, and verify that you didn't break anything
here.

thanks,

greg k-h
