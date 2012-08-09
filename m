Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2HIJVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:21:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50229 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab2HIJVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:21:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] mmc: sdio: Fix PM_SLEEP related build warnings
Date: Thu, 9 Aug 2012 11:27:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Chris Ball <cjb@laptop.org>, Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1344495413-7164-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1344495413-7164-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208091127.03119.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 09, 2012, Thierry Reding wrote:
> Power management callbacks defined by SIMPLE_DEV_PM_OPS are only used if
> the PM_SLEEP Kconfig symbol has been defined. If not, the compiler will
> complain about them being unused.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

The pm_no_operation() thing is not necessary at all, AFAICT.  I'd just
remove it entirely. :-)

Thanks,
Rafael


> ---
>  drivers/mmc/core/sdio_bus.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
> index 236842e..f8f90b4 100644
> --- a/drivers/mmc/core/sdio_bus.c
> +++ b/drivers/mmc/core/sdio_bus.c
> @@ -193,11 +193,12 @@ static int sdio_bus_remove(struct device *dev)
>  }
>  
>  #ifdef CONFIG_PM
> -
> +#ifdef CONFIG_PM_SLEEP
>  static int pm_no_operation(struct device *dev)
>  {
>  	return 0;
>  }
> +#endif
>  
>  static const struct dev_pm_ops sdio_bus_pm_ops = {
>  	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
> 

