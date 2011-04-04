Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1DDRQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:16:23 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:39156 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1DDRQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:16:22 -0400
Date: Mon, 4 Apr 2011 19:16:17 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Aisheng Dong <b29396@freescale.com>
Cc: hjk@hansjkoch.de, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uio: clean uioinfo when uninstall uio driver
Message-ID: <20110404171616.GB4830@local>
References: <1301734523-27933-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301734523-27933-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 04:55:23PM +0800, Aisheng Dong wrote:
> From: Jie Zhou <b30303@freescale.com>
> 
> The uioinfo should be cleaned up when uninstall, otherwise re-install
> failure of uio_pdrv_genirq.ko will happen.
> 
> Signed-off-by: Jie Zhou <b30303@freescale.com>
> Signed-off-by: Aisheng Dong <b29396@freescale.com>
> ---
>  drivers/uio/uio_pdrv_genirq.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 7174d51..e669a2c 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -189,6 +189,12 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
>  
>  	uio_unregister_device(priv->uioinfo);
>  	pm_runtime_disable(&pdev->dev);
> +
> +	priv->uioinfo->irq_flags = 0;

Why this one?

> +	priv->uioinfo->handler = NULL;
> +	priv->uioinfo->irqcontrol = NULL;

Both OK, good catch!

> +	priv->uioinfo->priv = NULL;

Why this one?

> +
>  	kfree(priv);
>  	return 0;
>  }

Thanks,
Hans

