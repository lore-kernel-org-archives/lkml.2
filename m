Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab1BPEkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:40:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43664 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab1BPEkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:40:19 -0500
Date: Tue, 15 Feb 2011 21:40:16 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Subject: Re: [PATCH v4] altera_ps2: Add devicetree support
Message-ID: <20110216044016.GC11684@angua.secretlab.ca>
References: <20110212092600.GE17755@angua.secretlab.ca>
 <1297649202-11200-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297649202-11200-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:06:42AM +0800, Thomas Chou wrote:
> From: Walter Goossens <waltergoossens@home.nl>
> 
> Signed-off-by: Walter Goossens <waltergoossens@home.nl>
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Merged, thanks,
g.

> ---
> v2 use const and add compat version.
> v3 change compatible vendor to ALTR.
>     add dts binding doc.
> v4 condition module device table export for of.
> 
> Grant, please take it through your tree as Dmitry agreed.
> 
>  .../devicetree/bindings/serio/altera_ps2.txt       |    4 ++++
>  drivers/input/serio/altera_ps2.c                   |   15 +++++++++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/serio/altera_ps2.txt
> 
> diff --git a/Documentation/devicetree/bindings/serio/altera_ps2.txt b/Documentation/devicetree/bindings/serio/altera_ps2.txt
> new file mode 100644
> index 0000000..4d9eecc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serio/altera_ps2.txt
> @@ -0,0 +1,4 @@
> +Altera UP PS/2 controller
> +
> +Required properties:
> +- compatible : should be "ALTR,ps2-1.0".
> diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
> index 7998560..3fee88b 100644
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
> @@ -173,6 +174,16 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id altera_ps2_match[] = {
> +	{ .compatible = "ALTR,ps2-1.0", },
> +	{},
> +}
> +MODULE_DEVICE_TABLE(of, altera_ps2_match);
> +#else /* CONFIG_OF */
> +#define altera_ps2_match NULL
> +#endif /* CONFIG_OF */
> +
>  /*
>   * Our device driver structure
>   */
> @@ -182,6 +193,7 @@ static struct platform_driver altera_ps2_driver = {
>  	.driver	= {
>  		.name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
> +		.of_match_table = altera_ps2_match,
>  	},
>  };
>  
> @@ -189,13 +201,12 @@ static int __init altera_ps2_init(void)
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
> 1.7.4
> 
