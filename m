Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0KCKIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:08:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43870 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0KCKIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:08:10 -0400
Subject: Re: [PATCH v2] regulator: regulator disable supply fix
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1288706135-30836-1-git-send-email-mattias.wallin@stericsson.com>
References: <1288706135-30836-1-git-send-email-mattias.wallin@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 10:08:05 +0000
Message-ID: <1288778885.3277.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 14:55 +0100, Mattias Wallin wrote:
> This patch fixes a disable failure when regulator supply is used.
> A while loop in regulator disable checks for supply pointer != NULL
> but the pointer is not always updated, resulting in the while loop
> running too many times causing a disable failure.
> 
> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index f1d10c9..c625633 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1359,6 +1359,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
>  		struct regulator_dev **supply_rdev_ptr)
>  {
>  	int ret = 0;
> +	*supply_rdev_ptr = NULL;
>  
>  	if (WARN(rdev->use_count <= 0,
>  			"unbalanced disables for %s\n",

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

