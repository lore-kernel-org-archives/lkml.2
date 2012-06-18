Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab2FREhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:37:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48090 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2FREhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:37:16 -0400
Date: Sun, 17 Jun 2012 21:35:26 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: pda_power: Complain if regulator
 operations fail
Message-ID: <20120618043526.GB25372@lizard>
References: <1339465586-10841-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339465586-10841-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 09:46:26AM +0800, Mark Brown wrote:
> Rather than silently ignoring errors from the regulator enable and disable
> add a WARN_ON() - it's probably pretty important if we're not getting
> power, though it should be vanishingly unlikely in production.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied, thanks!

>  drivers/power/pda_power.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> index 214468f..ed54a35 100644
> --- a/drivers/power/pda_power.c
> +++ b/drivers/power/pda_power.c
> @@ -134,13 +134,13 @@ static void update_charger(void)
>  			regulator_set_current_limit(ac_draw, max_uA, max_uA);
>  			if (!regulator_enabled) {
>  				dev_dbg(dev, "charger on (AC)\n");
> -				regulator_enable(ac_draw);
> +				WARN_ON(regulator_enable(ac_draw));
>  				regulator_enabled = 1;
>  			}
>  		} else {
>  			if (regulator_enabled) {
>  				dev_dbg(dev, "charger off\n");
> -				regulator_disable(ac_draw);
> +				WARN_ON(regulator_disable(ac_draw));
>  				regulator_enabled = 0;
>  			}
>  		}
> -- 
> 1.7.10

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
