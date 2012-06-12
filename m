Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2FLAB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:01:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2FLABz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:01:55 -0400
Date: Mon, 11 Jun 2012 17:01:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, aaro.koskinen@iki.fi, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Staging: xgifb: reorder the code a bit to be more
 module friendly
Message-ID: <20120612000151.GA16887@kroah.com>
References: <1338992527-5659-1-git-send-email-magomez@igalia.com>
 <1338992527-5659-2-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1338992527-5659-2-git-send-email-magomez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 04:22:05PM +0200, Miguel Gómez wrote:
> Signed-off-by: Miguel Gómez <magomez@igalia.com>
> ---
>  drivers/staging/xgifb/XGI_main_26.c |   51 +++++++++++++++++------------------
>  1 file changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
> index 61dc7cb..96abb23 100644
> --- a/drivers/staging/xgifb/XGI_main_26.c
> +++ b/drivers/staging/xgifb/XGI_main_26.c
> @@ -2306,49 +2306,44 @@ static struct pci_driver xgifb_driver = {
>  	.remove = __devexit_p(xgifb_remove)
>  };
>  
> -static int __init xgifb_init(void)
> -{
> -	char *option = NULL;
> -
> -	if (forcecrt2type != NULL)
> -		XGIfb_search_crt2type(forcecrt2type);
> -	if (fb_get_options("xgifb", &option))
> -		return -ENODEV;
> -	XGIfb_setup(option);
> -
> -	return pci_register_driver(&xgifb_driver);
> -}
>  
> -module_init(xgifb_init);
>  
>  /*****************************************************/
>  /*                      MODULE                       */
>  /*****************************************************/
>  
> -MODULE_DESCRIPTION("Z7 Z9 Z9S Z11 framebuffer device driver");
> -MODULE_LICENSE("GPL");
> -MODULE_AUTHOR("XGITECH , Others");
> -
>  module_param(mode, charp, 0);
> -module_param(vesa, int, 0);
> -module_param(filter, int, 0);
> -module_param(forcecrt2type, charp, 0);
> +MODULE_PARM_DESC(mode,
> +	"\nSelects the desired default display mode in the format XxYxDepth,\n"
> +	"eg. 1024x768x16.\n");
>  
> +module_param(forcecrt2type, charp, 0);
>  MODULE_PARM_DESC(forcecrt2type,
>  	"\nForce the second display output type. Possible values are NONE,\n"
>  	"LCD, TV, VGA, SVIDEO or COMPOSITE.\n");

What's with these "\n" in the string?  Shouldn't those be removed?

thanks,

greg k-h
