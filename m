Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1DFVMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:12:19 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:43307 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab1DFVMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:12:18 -0400
Date: Wed, 6 Apr 2011 23:12:15 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Aisheng Dong <b29396@freescale.com>
Cc: hjk@hansjkoch.de, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/1] uio: clean uioinfo when uninstall uio driver
Message-ID: <20110406211214.GA2795@local>
References: <1302072160-6483-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302072160-6483-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 02:42:40PM +0800, Aisheng Dong wrote:
> From: Jie Zhou <b30303@freescale.com>
> 
> The uioinfo should be cleaned up when uninstall, otherwise re-install
> failure of uio_pdrv_genirq.ko will happen.

Looks good.

Thanks for your help,
Hans

> 
> Signed-off-by: Jie Zhou <b30303@freescale.com>
> Signed-off-by: Aisheng Dong <b29396@freescale.com>

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>

> 
> ---
> Changes for v2:
>  Address the comments from Hans:
>    - The uioinfo->irq_flags and uioinfo->priv do not have to be cleaned
> ---
>  drivers/uio/uio_pdrv_genirq.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 7174d51..0f424af 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -189,6 +189,10 @@ static int uio_pdrv_genirq_remove(struct platform_device *pdev)
>  
>  	uio_unregister_device(priv->uioinfo);
>  	pm_runtime_disable(&pdev->dev);
> +
> +	priv->uioinfo->handler = NULL;
> +	priv->uioinfo->irqcontrol = NULL;
> +
>  	kfree(priv);
>  	return 0;
>  }
> -- 
> 1.7.0.4
> 
> 
> 
