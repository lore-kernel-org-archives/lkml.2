Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463Ab2EJAZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:25:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34950 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2EJAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:25:08 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi/topcliff: use correct __devexit_p annotation
To: mathieu.poirier@linaro.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        arnd@arndb.de, mathieu.poirier@linaro.org
In-Reply-To: <1336602923-5724-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336602923-5724-1-git-send-email-mathieu.poirier@linaro.org>
Date: Wed, 09 May 2012 18:25:05 -0600
Message-Id: <20120510002505.172243E08F4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 May 2012 16:35:23 -0600, mathieu.poirier@linaro.org wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> __devexit functions are discarded when CONFIG_HOTPLUG
> is not set, so the symbol needs to be referenced carefully.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

Applied, thanks.

g.

> ---
>  drivers/spi/spi-topcliff-pch.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> index ec47d3b..77c4562 100644
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -1779,7 +1779,7 @@ static struct pci_driver pch_spi_pcidev_driver = {
>  	.name = "pch_spi",
>  	.id_table = pch_spi_pcidev_id,
>  	.probe = pch_spi_probe,
> -	.remove = pch_spi_remove,
> +	.remove = __devexit_p(pch_spi_remove),
>  	.suspend = pch_spi_suspend,
>  	.resume = pch_spi_resume,
>  };
> -- 
> 1.7.5.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
