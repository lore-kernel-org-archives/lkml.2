Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1E3MvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:51:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63236 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1E3MvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:51:13 -0400
Subject: Re: [PATCH] regulator: twl-regulator: fix n_voltages for twl6030
 variable LDOs
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1306524327-24150-1-git-send-email-ccross@android.com>
References: <1306524327-24150-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 13:51:06 +0100
Message-ID: <1306759866.3227.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 12:25 -0700, Colin Cross wrote:
> The n_voltages initializer for the TWL6030_ADJUSTABLE_LDO macro is
> off by one, causing the the highest supported voltage to be
> unreachable.  Setting the machine constraints to only allow the
> highest voltage causes errors:
> 
> machine_constraints_voltage: VAUX3_6030: unsupportable voltage constraints
> twl_reg twl_reg.39: can't register VAUX3_6030, -22
> twl_reg: probe of twl_reg.39 failed with error -22
> 
> This patch fixes the off by one error.  Tested by setting
> VAUX3_6030 to 3.3V.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/regulator/twl-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
> index 6a29285..afd9c7e 100644
> --- a/drivers/regulator/twl-regulator.c
> +++ b/drivers/regulator/twl-regulator.c
> @@ -520,7 +520,7 @@ static struct regulator_ops twl6030_fixed_resource = {
>  	.desc = { \
>  		.name = #label, \
>  		.id = TWL6030_REG_##label, \
> -		.n_voltages = (max_mVolts - min_mVolts)/100, \
> +		.n_voltages = (max_mVolts - min_mVolts)/100 + 1, \
>  		.ops = &twl6030ldo_ops, \
>  		.type = REGULATOR_VOLTAGE, \
>  		.owner = THIS_MODULE, \

Applied.

Thanks

Liam

