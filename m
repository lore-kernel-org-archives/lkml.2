Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0HRN3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:29:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64096 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0HRN3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:29:40 -0400
Subject: Re: [PATCH] regulator: ab8500 - fix the logic to remove already
 registered regulators in error path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>
In-Reply-To: <1281793444.2974.5.camel@phoenix>
References: <1281793444.2974.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 14:29:35 +0100
Message-ID: <1282138175.3117.424.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-14 at 21:44 +0800, Axel Lin wrote:
> In current implementation, ab8500_regulator_info[0].regulator is not
> unregistered if the error happen at i > 0.
> 
> This patch fixes the resource leak and also improves the readability.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I think this change is better ( in readability ) than simply change "while (i > 0)" to "while (i >= 0)".
> 
>  drivers/regulator/ab8500.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index dc3f1a4..775688e 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -368,11 +368,9 @@ static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
>  			dev_err(&pdev->dev, "failed to register regulator %s\n",
>  					info->desc.name);
>  			/* when we fail, un-register all earlier regulators */
> -			i--;
> -			while (i > 0) {
> +			while (--i >= 0) {
>  				info = &ab8500_regulator_info[i];
>  				regulator_unregister(info->regulator);
> -				i--;
>  			}
>  			return err;
>  		}

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

