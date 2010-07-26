Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0GZHGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:06:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49624 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753484Ab0GZHGD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:06:03 -0400
References: <1280122549.20830.1.camel@mola> (sfid-20100726_063529_143771_2699E6C4)
Message-Id: <F5EFB125-5C73-4DE5-8A4F-E0E92102D4F5@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
In-Reply-To: <1280122549.20830.1.camel@mola> (sfid-20100726_063529_143771_2699E6C4)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B405)
Mime-Version: 1.0 (iPad Mail 7B405)
Subject: Re: [PATCH] ab3100: fix off-by-one value range checking for voltage selector
Date: Mon, 26 Jul 2010 00:06:15 -0700
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Jul 2010, at 22:35, Axel Lin <axel.lin@gmail.com> wrote:

> The valid typ_voltages range should be 0..voltages_len-1.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

It'd be nice to include a few extra words in the change log explaining that the reason for the limit is that it's an array index.

> ---
> drivers/regulator/ab3100.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
> index 7b14a67..1179099 100644
> --- a/drivers/regulator/ab3100.c
> +++ b/drivers/regulator/ab3100.c
> @@ -286,7 +286,7 @@ static int ab3100_list_voltage_regulator(struct regulator_dev *reg,
> {
>  	struct ab3100_regulator *abreg = reg->reg_data;
> 
> -	if (selector > abreg->voltages_len)
> +	if (selector >= abreg->voltages_len)
>  		return -EINVAL;
>  	return abreg->typ_voltages[selector];
> }
> @@ -318,7 +318,7 @@ static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
>  	regval &= 0xE0;
>  	regval >>= 5;
> 
> -	if (regval > abreg->voltages_len) {
> +	if (regval >= abreg->voltages_len) {
>  		dev_err(&reg->dev,
>  			"regulator register %02x contains an illegal voltage setting\n",
>  			abreg->regreg);
> -- 
> 1.5.4.3
> 
> 
> 
