Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab0KXKv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:51:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55000 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0KXKv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:51:27 -0500
Subject: Re: [PATCH] ASoC: nuc900-ac97: fix a memory leak
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1290588263.7545.1.camel@mola>
References: <1290588263.7545.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 10:51:22 +0000
Message-ID: <1290595882.3332.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 16:44 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/nuc900/nuc900-ac97.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
> index 293dc74..e00e39d 100644
> --- a/sound/soc/nuc900/nuc900-ac97.c
> +++ b/sound/soc/nuc900/nuc900-ac97.c
> @@ -384,7 +384,6 @@ out0:
>  
>  static int __devexit nuc900_ac97_drvremove(struct platform_device *pdev)
>  {
> -
>  	snd_soc_unregister_dai(&pdev->dev);
>  
>  	clk_put(nuc900_ac97_data->clk);
> @@ -392,6 +391,7 @@ static int __devexit nuc900_ac97_drvremove(struct platform_device *pdev)
>  	release_mem_region(nuc900_ac97_data->res->start,
>  				resource_size(nuc900_ac97_data->res));
>  
> +	kfree(nuc900_ac97_data);
>  	nuc900_ac97_data = NULL;
>  
>  	return 0;


Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

