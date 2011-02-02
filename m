Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1BBEb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 23:31:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36384 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1BBEb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 23:31:27 -0500
Date: Tue, 1 Feb 2011 21:31:21 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Subject: Re: [PATCH v2] altera_ps2: Add devicetree support
Message-ID: <20110202043121.GF29148@angua.secretlab.ca>
References: <20110117220415.GB17963@angua.secretlab.ca>
 <1295848693-28472-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295848693-28472-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 01:58:13PM +0800, Thomas Chou wrote:
> From: Walter Goossens <waltergoossens@home.nl>
> 
> Signed-off-by: Walter Goossens <waltergoossens@home.nl>
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
> v2 use const and add compat version.
> 
>  drivers/input/serio/altera_ps2.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
> index 7998560..63325ee 100644
> --- a/drivers/input/serio/altera_ps2.c
> +++ b/drivers/input/serio/altera_ps2.c
> @@ -19,6 +19,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
>  
>  #define DRV_NAME "altera_ps2"
>  
> @@ -173,6 +174,12 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id altera_ps2_match[] = {
> +	{ .compatible = "altr,ps2-1.0", },

I thought I had seen 'altera' instead of an abbreviation being used in
a previous patch.  I don't care much whether 'altr' or 'altera' is
used, but I'd like to know that there is consensus from the Altera
users so that all the drivers use the same prefix.

> +	{},
> +}
> +MODULE_DEVICE_TABLE(of, altera_ps2_match);
> +
>  /*
>   * Our device driver structure
>   */
> @@ -182,6 +189,7 @@ static struct platform_driver altera_ps2_driver = {
>  	.driver	= {
>  		.name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
> +		.of_match_table = altera_ps2_match,

At the moment, this patch can only be applied against my
devicetree/next branch since there is a #ifdef CONFIG_OF around
of_match_table in mainline, and the patch to remove it is in my next
branch.  I'm okay with taking it through my tree if Dmitry agrees.

g.

>  	},
>  };
>  
> @@ -189,13 +197,12 @@ static int __init altera_ps2_init(void)
>  {
>  	return platform_driver_register(&altera_ps2_driver);
>  }
> +module_init(altera_ps2_init);
>  
>  static void __exit altera_ps2_exit(void)
>  {
>  	platform_driver_unregister(&altera_ps2_driver);
>  }
> -
> -module_init(altera_ps2_init);
>  module_exit(altera_ps2_exit);
>  
>  MODULE_DESCRIPTION("Altera University Program PS2 controller driver");
> -- 
> 1.7.3.4
> 
