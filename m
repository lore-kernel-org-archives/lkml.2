Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1GHS2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:28:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38182 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1GHS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:28:16 -0400
Subject: Re: [PATCH] regulator: max8997: Fix setting inappropriate value
 for ramp_delay variable
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
In-Reply-To: <1310025116-30787-1-git-send-email-dg77.kim@samsung.com>
References: <1310025116-30787-1-git-send-email-dg77.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 19:28:11 +0100
Message-ID: <1310149691.3348.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 16:51 +0900, Donggeun Kim wrote:
> The ramp_delay variable can be set lower than the desired value.
> This patch fixes it.
> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
> ---
>  drivers/regulator/max8997.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index 10d5a1d..682bc79 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -543,7 +543,8 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
>  			rid == MAX8997_BUCK4 || rid == MAX8997_BUCK5) {
>  		/* If the voltage is increasing */
>  		if (org < i)
> -			udelay(desc->step * (i - org) / max8997->ramp_delay);
> +			udelay(DIV_ROUND_UP(desc->step * (i - org),
> +						max8997->ramp_delay));
>  	}
>  
>  	return ret;

Applied.

