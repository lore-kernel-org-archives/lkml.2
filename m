Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab2KNRzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:55:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20712 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2KNRzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:55:41 -0500
Date: Wed, 14 Nov 2012 20:55:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org, wfp5p@virginia.edu,
        geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] staging: dgrp: dgrp_tty.c: return an -EFAULT if
 put_user fails
Message-ID: <20121114175512.GJ11515@mwanda>
References: <1352893057-27226-1-git-send-email-gmate.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352893057-27226-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 05:07:37PM +0530, Kumar Amit Mehta wrote:
> Inspect the return value of put_user() and return -EFAULT on error.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  drivers/staging/dgrp/dgrp_tty.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
> index e125b03..cebd3a1 100644
> --- a/drivers/staging/dgrp/dgrp_tty.c
> +++ b/drivers/staging/dgrp/dgrp_tty.c
> @@ -2265,9 +2265,7 @@ static int get_modem_info(struct ch_struct *ch, unsigned int *value)
>  		| ((mlast & DM_RI)  ? TIOCM_RNG : 0)
>  		| ((mlast & DM_DSR) ? TIOCM_DSR : 0)
>  		| ((mlast & DM_CTS) ? TIOCM_CTS : 0);
> -	put_user(mlast, (unsigned int __user *) value);
> -
> -	return 0;
> +	return put_user(mlast, (unsigned int __user *) value);
>  }
>  
>  /*
> @@ -2620,7 +2618,8 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
>  			       sizeof(long));
>  		if (rc == 0)
>  			return -EFAULT;
> -		put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg);
> +		if (put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg))
> +			return -EFAULT;
>  		return 0;

This one could just be return put_user() as well.

regards,
dan carpenter

