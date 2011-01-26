Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1AZFw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 00:52:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49018 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1AZFw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 00:52:57 -0500
MIME-Version: 1.0
In-Reply-To: <1296019325-17801-1-git-send-email-thomas@wytron.com.tw>
References: <20110125.194532.71125517.davem@davemloft.net> <1296019325-17801-1-git-send-email-thomas@wytron.com.tw>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jan 2011 22:52:36 -0700
X-Google-Sender-Auth: 0VrzJzh9A0WuI_eRO2tirPrCNgM
Message-ID: <AANLkTindbigYzY0zJufpr-D25m_B5Gjqp09ZbcaN-aZ9@mail.gmail.com>
Subject: Re: [PATCH v4] smc91x: add devicetree support
To: Thomas Chou <thomas@wytron.com.tw>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        Nicolas Pitre <nico@fluxnic.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 10:22 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
> v2 specify part numbers in compat as Grant suggested.
> v3 more specific part name.
> v4 include match table only for OF as David suggested.
>
>  drivers/net/smc91x.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)

Looks okay to me.

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

>
> diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
> index 726df61..43654a3 100644
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
> @@ -2394,6 +2395,15 @@ static int smc_drv_resume(struct device *dev)
>        return 0;
>  }
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id smc91x_match[] = {
> +       { .compatible = "smsc,lan91c94", },
> +       { .compatible = "smsc,lan91c111", },
> +       {},
> +}
> +MODULE_DEVICE_TABLE(of, smc91x_match);
> +#endif
> +
>  static struct dev_pm_ops smc_drv_pm_ops = {
>        .suspend        = smc_drv_suspend,
>        .resume         = smc_drv_resume,
> @@ -2406,6 +2416,9 @@ static struct platform_driver smc_driver = {
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
