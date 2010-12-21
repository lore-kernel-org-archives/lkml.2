Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab0LUM6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 07:58:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57553 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0LUM6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 07:58:37 -0500
Subject: Re: [PATCH 1/2] regulator: max8952 - fix max8952_set_voltage check
 condition.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <1292907880-3353-1-git-send-email-myungjoo.ham@samsung.com>
References: <1292907880-3353-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 12:58:32 +0000
Message-ID: <1292936312.3296.8.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 14:04 +0900, MyungJoo Ham wrote:
> In the current implementation, the GPIO pin, vid0 is checked twice
> (duplicated!) while vid1 is never checked; however, both vid0 and
> vid1 should be checked. This patch fixes the typo that stated vid0 where
> should've stated vid1.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/regulator/max8952.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
> index 0d5dda4..c7dae2b 100644
> --- a/drivers/regulator/max8952.c
> +++ b/drivers/regulator/max8952.c
> @@ -139,7 +139,7 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
>  	s8 vid = -1, i;
>  
>  	if (!gpio_is_valid(max8952->pdata->gpio_vid0) ||
> -			!gpio_is_valid(max8952->pdata->gpio_vid0)) {
> +			!gpio_is_valid(max8952->pdata->gpio_vid1)) {
>  		/* DVS not supported */
>  		return -EPERM;
>  	}

Does this series depend on your MFD MAX8998/LP3974 hibernation, charger
patch ?

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

