Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab1BYIzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:55:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39071 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab1BYIzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:55:19 -0500
Subject: Re: [PATCH] regulator, mc13xxx: Remove pointless test for unsigned
 less than zero
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Yong Shen <yong.shen@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>
In-Reply-To: <alpine.LNX.2.00.1102232341030.28678@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102232341030.28678@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 08:55:13 +0000
Message-ID: <1298624113.3363.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 23:45 +0100, Jesper Juhl wrote:
> The variable 'val' is a 'unsigned int', so it can never be less than zero. 
> This fact makes the "val < 0" part of the test done in BUG_ON() in 
> mc13xxx_regulator_get_voltage() rather pointles since it can never have 
> any effect.
> This patch removes the pointless test.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  mc13xxx-regulator-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
> index f53d31b..2bb5de1 100644
> --- a/drivers/regulator/mc13xxx-regulator-core.c
> +++ b/drivers/regulator/mc13xxx-regulator-core.c
> @@ -174,7 +174,7 @@ static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
>  
>  	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
>  
> -	BUG_ON(val < 0 || val > mc13xxx_regulators[id].desc.n_voltages);
> +	BUG_ON(val > mc13xxx_regulators[id].desc.n_voltages);
>  
>  	return mc13xxx_regulators[id].voltages[val];
>  }
> 

Applied.

Thanks

Liam


