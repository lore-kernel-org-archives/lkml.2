Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2E0CxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 22:53:06 -0400
Received: from void.printf.net ([89.145.121.20]:55316 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab2E0CxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 22:53:03 -0400
From: Chris Ball <cjb@laptop.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: core: Fix build warning with !CONFIG_SUSPEND
References: <1337414319-27719-1-git-send-email-santosh.shilimkar@ti.com>
Date: Sat, 26 May 2012 22:52:56 -0400
In-Reply-To: <1337414319-27719-1-git-send-email-santosh.shilimkar@ti.com>
	(Santosh Shilimkar's message of "Sat, 19 May 2012 13:28:39 +0530")
Message-ID: <87d35q1gjb.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 19 2012, Santosh Shilimkar wrote:
> With !CONFIG_SUSPEND, mmc core layer throws below build warnings.
>
> drivers/mmc/core/bus.c:125: warning: 'mmc_bus_suspend' defined but not used
> drivers/mmc/core/bus.c:136: warning: 'mmc_bus_resume' defined but not used
> drivers/mmc/core/sdio_bus.c:197: warning: 'pm_no_operation' defined but not used
>
> Fix is by wrapping suspend hooks under CONFIG_SUSPEND
>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mmc/core/bus.c      |    2 ++
>  drivers/mmc/core/sdio_bus.c |    2 +-
>  2 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index c60cee9..ca8925d 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -122,6 +122,7 @@ static int mmc_bus_remove(struct device *dev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_SUSPEND
>  static int mmc_bus_suspend(struct device *dev)
>  {
>  	struct mmc_driver *drv = to_mmc_driver(dev->driver);
> @@ -143,6 +144,7 @@ static int mmc_bus_resume(struct device *dev)
>  		ret = drv->resume(card);
>  	return ret;
>  }
> +#endif
>  
>  #ifdef CONFIG_PM_RUNTIME
>  
> diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
> index 236842e..87d1b7e 100644
> --- a/drivers/mmc/core/sdio_bus.c
> +++ b/drivers/mmc/core/sdio_bus.c
> @@ -192,7 +192,7 @@ static int sdio_bus_remove(struct device *dev)
>  	return ret;
>  }
>  
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_SUSPEND
>  
>  static int pm_no_operation(struct device *dev)
>  {

This patch doesn't apply against mmc-next, and I think this has already
been fixed upstream -- please could you retest against Linus HEAD?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
