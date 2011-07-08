Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab1GHNJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:09:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61603 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1GHNI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:08:59 -0400
Date: Fri, 8 Jul 2011 17:08:54 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] twl4030_charger: fix warnings
Message-ID: <20110708130854.GC29056@oksana.dev.rtsoft.ru>
References: <1307101391-10898-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307101391-10898-1-git-send-email-notasas@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 02:43:11PM +0300, Grazvydas Ignotas wrote:
> Fix warnings emitted by some versions of gcc:
> drivers/power/twl4030_charger.c:490: warning: overflow in implicit constant conversion
> drivers/power/twl4030_charger.c:498: warning: overflow in implicit constant conversion
> 
> While at it, also fix module_param permissions and a typo in my name.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---

Applied, thanks.

I also added Jean's sign-off for the module_param persmissions
fix.

>  drivers/power/twl4030_charger.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
> index 92c16e1..54b9198 100644
> --- a/drivers/power/twl4030_charger.c
> +++ b/drivers/power/twl4030_charger.c
> @@ -62,7 +62,7 @@
>  #define TWL4030_MSTATEC_COMPLETE4	0x0e
>  
>  static bool allow_usb;
> -module_param(allow_usb, bool, 1);
> +module_param(allow_usb, bool, 0644);
>  MODULE_PARM_DESC(allow_usb, "Allow USB charge drawing default current");
>  
>  struct twl4030_bci {
> @@ -425,7 +425,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
>  {
>  	struct twl4030_bci *bci;
>  	int ret;
> -	int reg;
> +	u32 reg;
>  
>  	bci = kzalloc(sizeof(*bci), GFP_KERNEL);
>  	if (bci == NULL)
> @@ -486,7 +486,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Enable interrupts now. */
> -	reg = ~(TWL4030_ICHGLOW | TWL4030_ICHGEOC | TWL4030_TBATOR2 |
> +	reg = ~(u32)(TWL4030_ICHGLOW | TWL4030_ICHGEOC | TWL4030_TBATOR2 |
>  		TWL4030_TBATOR1 | TWL4030_BATSTS);
>  	ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, reg,
>  			       TWL4030_INTERRUPTS_BCIIMR1A);
> @@ -495,7 +495,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
>  		goto fail_unmask_interrupts;
>  	}
>  
> -	reg = ~(TWL4030_VBATOV | TWL4030_VBUSOV | TWL4030_ACCHGOV);
> +	reg = ~(u32)(TWL4030_VBATOV | TWL4030_VBUSOV | TWL4030_ACCHGOV);
>  	ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, reg,
>  			       TWL4030_INTERRUPTS_BCIIMR2A);
>  	if (ret < 0)
> @@ -572,7 +572,7 @@ static void __exit twl4030_bci_exit(void)
>  }
>  module_exit(twl4030_bci_exit);
>  
> -MODULE_AUTHOR("Gražydas Ignotas");
> +MODULE_AUTHOR("Gražvydas Ignotas");
>  MODULE_DESCRIPTION("TWL4030 Battery Charger Interface driver");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:twl4030_bci");
> -- 
> 1.7.0.4
> 

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
