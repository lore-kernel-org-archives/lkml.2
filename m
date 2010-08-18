Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0HRN3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:29:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46417 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab0HRN3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:29:31 -0400
Subject: Re: [PATCH] regulator: ab3100 - fix the logic to remove already
 registered regulators in error path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
In-Reply-To: <1281792661.2718.4.camel@phoenix>
References: <1281792661.2718.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 14:29:26 +0100
Message-ID: <1282138166.3117.421.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-14 at 21:31 +0800, Axel Lin wrote:
> In current implementation, ab3100_regulators[0].rdev is not unregistered if
> the error happen at i > 0.
> 
> This patch fixes the resource leak and also improves the readability.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I think this change is better ( in readability ) than simply change "while (i > 0)" to "while (i >= 0)".
> 
>  drivers/regulator/ab3100.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
> index 1179099..b349266 100644
> --- a/drivers/regulator/ab3100.c
> +++ b/drivers/regulator/ab3100.c
> @@ -634,12 +634,9 @@ static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
>  				"%s: failed to register regulator %s err %d\n",
>  				__func__, ab3100_regulator_desc[i].name,
>  				err);
> -			i--;
>  			/* remove the already registered regulators */
> -			while (i > 0) {
> +			while (--i >= 0)
>  				regulator_unregister(ab3100_regulators[i].rdev);
> -				i--;
> -			}
>  			return err;
>  		}
>  

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

