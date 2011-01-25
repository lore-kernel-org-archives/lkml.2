Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1AYGYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:24:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1AYGYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <1295935170-19518-1-git-send-email-thomas@wytron.com.tw>
References: <1295935170-19518-1-git-send-email-thomas@wytron.com.tw>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 24 Jan 2011 23:24:16 -0700
X-Google-Sender-Auth: licMKHYKlzgb8gitq3SMDrEPeJM
Message-ID: <AANLkTikgsqJqdW2qh7h4yATCmGFb5MkHCosma_DOBq-Y@mail.gmail.com>
Subject: Re: [PATCH] smc91x: add devicetree support
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:59 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
>  drivers/net/smc91x.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
> index 726df61..d29e18d 100644
> --- a/drivers/net/smc91x.c
> +++ b/drivers/net/smc91x.c
> @@ -81,6 +81,7 @@ static const char version[] =
>  #include <linux/ethtool.h>
>  #include <linux/mii.h>
>  #include <linux/workqueue.h>
> +#include <linux/of.h>
>
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
> @@ -2394,6 +2395,12 @@ static int smc_drv_resume(struct device *dev)
>        return 0;
>  }
>
> +static const struct of_device_id smc91x_match[] = {
> +       { .compatible = "smsc,smc91x", },

Be specific.  What *exact* smsc device are you adding support for?
Wildcards like smc91x tend to cause problems in the future.

> +       {},
> +}
> +MODULE_DEVICE_TABLE(of, smc91x_match);
> +
>  static struct dev_pm_ops smc_drv_pm_ops = {
>        .suspend        = smc_drv_suspend,
>        .resume         = smc_drv_resume,
> @@ -2406,6 +2413,9 @@ static struct platform_driver smc_driver = {
>                .name   = CARDNAME,
>                .owner  = THIS_MODULE,
>                .pm     = &smc_drv_pm_ops,
> +#ifdef CONFIG_OF
> +               .of_match_table = smc91x_match,
> +#endif
>        },
>  };
>
> --
> 1.7.3.5
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
