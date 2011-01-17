Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1AQVbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:31:16 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:51898 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1AQVbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:31:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wHCuQOSFhoz8KhpMcmDxyEV/wIsiIxsV/U+1UxVWFH5RB1ZbszaCSpZojFoRp1hwHT
         dixodF1ySdqcOupmy/6SVgSJnpZxVD5zak9gVAOUorTnU1R+oebAuVLVGqM+XyTWzOjB
         jj2meqWNZj6VV9bvEb691JNNAPkAOVM8PjmYM=
Date: Mon, 17 Jan 2011 13:31:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Subject: Re: [PATCH] alter_ps2: Add devicetree support
Message-ID: <20110117213100.GC27245@core.coreip.homeip.net>
References: <4D040D1C.2020705@home.nl>
 <1295245760-4566-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295245760-4566-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 02:29:20PM +0800, Thomas Chou wrote:
> From: Walter Goossens <waltergoossens@home.nl>
> 

For my education, why is this needed?

> Signed-off-by: Walter Goossens <waltergoossens@home.nl>
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
>  drivers/input/serio/altera_ps2.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
> index 7998560..93054a1 100644
> --- a/drivers/input/serio/altera_ps2.c
> +++ b/drivers/input/serio/altera_ps2.c
> @@ -19,6 +19,9 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#ifdef CONFIG_OF
> +#include <linux/of.h>
> +#endif

Does it have to be guarded?

>  
>  #define DRV_NAME "altera_ps2"
>  
> @@ -173,6 +176,16 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static struct of_device_id altera_ps2_match[] = {

Not const?

> +	{ 
> +		.compatible = "altera,altera_ps2",
> +	},
> +	{},
> +}
> +MODULE_DEVICE_TABLE(of, altera_jtaguart_match);
> +#endif /* CONFIG_OF */
> +
>  /*
>   * Our device driver structure
>   */
> @@ -182,6 +195,9 @@ static struct platform_driver altera_ps2_driver = {
>  	.driver	= {
>  		.name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
> +#ifdef CONFIG_OF
> +		.of_match_table = altera_ps2_match,
> +#endif

Can't we spare 4 bytes per driver and have .of_match_table always
present?

-- 
Dmitry
