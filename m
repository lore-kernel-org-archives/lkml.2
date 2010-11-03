Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0KCNuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:50:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42063 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0KCNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sgt4ACp6m7sFxdTaK7rMG9VRPY9FzmtxAxTRN3Wqa9adIU6xAPta/j0sz53UTRNNes
         IaRBH7kCR9JWGVreq1C1qo0aYSiM5wOKoBRgaDmTPszU5/X9QMlFY1QkO1mvSMWiO2Cs
         jd2Tv8D667VcEqgycQ1F/PC2Vjgp42MpnOdRE=
Subject: Re: [PATCH] regulator: Staticise mc13783_powermisc_rmw()
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Sascha Hauer <s.hauer@pengutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1288757284-15812-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1288757284-15812-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 14:50:08 +0100
Message-ID: <1288792208.3311.96.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mer, 2010-11-03 at 00:08 -0400, Mark Brown wrote:
> It is not used outside this driver so no need to make the symbol global.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

It's OK for me, because no other functionalities than regulator's one
are influenced by the Power Misc register.

Acked-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

> ---
>  drivers/regulator/mc13783-regulator.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
> index 5e6fa47..47ea999 100644
> --- a/drivers/regulator/mc13783-regulator.c
> +++ b/drivers/regulator/mc13783-regulator.c
> @@ -471,8 +471,8 @@ static struct regulator_ops mc13783_fixed_regulator_ops = {
>  	.get_voltage = mc13783_fixed_regulator_get_voltage,
>  };
>  
> -int mc13783_powermisc_rmw(struct mc13783_regulator_priv *priv, u32 mask,
> -									u32 val)
> +static int mc13783_powermisc_rmw(struct mc13783_regulator_priv *priv, u32 mask,
> +				 u32 val)
>  {
>  	struct mc13783 *mc13783 = priv->mc13783;
>  	int ret;


-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

