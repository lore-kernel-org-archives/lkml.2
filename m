Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2KDIN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 03:13:27 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56854 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab2KDIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 03:13:26 -0500
Message-ID: <509623B0.2020605@metafoo.de>
Date: Sun, 04 Nov 2012 09:13:36 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121027 Icedove/3.0.11
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [PATCH 5/9] ASoC: Only compile adav80x codec when
 a	bus is defined
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org> <1351980150-24145-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1351980150-24145-6-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 11:02 PM, Lee Jones wrote:
> If !CONFIG_SPI and !CONFIG_I2C* then there is no point adding support
> for the adav80x codec as it relies on a bus to operate. This patch
> fixes the build warnings below when SPI and I2C are not specified in
> the configuration.
> 
> sound/soc/codecs/adav80x.c:842:22: warning: ‘adav80x_bus_probe’ defined but not used [-Wunused-function]
> sound/soc/codecs/adav80x.c:863:22: warning: ‘adav80x_bus_remove’ defined but not used [-Wunused-function]
> 
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  sound/soc/codecs/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
> index b92759a..0d8135a 100644
> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig
> @@ -19,7 +19,7 @@ config SND_SOC_ALL_CODECS
>  	select SND_SOC_AD1980 if SND_SOC_AC97_BUS
>  	select SND_SOC_AD73311
>  	select SND_SOC_ADAU1373 if I2C
> -	select SND_SOC_ADAV80X
> +	select SND_SOC_ADAV80X if (I2C || I2C_MODULE || SPI_MASTER)

That should be 'if SND_SOC_I2C_AND_SPI', but otherwise agreed.

>  	select SND_SOC_ADS117X
>  	select SND_SOC_AK4104 if SPI_MASTER
>  	select SND_SOC_AK4535 if I2C

