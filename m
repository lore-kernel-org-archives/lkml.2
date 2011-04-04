Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1DDI5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 04:57:10 -0400
Received: from router.aksignal.cz ([188.175.113.102]:41852 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1DDI5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 04:57:09 -0400
Message-ID: <4D9987DD.8040703@aksignal.cz>
Date: Mon, 04 Apr 2011 10:57:01 +0200
From: =?UTF-8?B?UHJjaGFsIEppxZnDrQ==?= <jiri.prchal@aksignal.cz>
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Lightning/1.0b1 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>
CC: alsa-devel@vger.kernel.org, alsa-devel@alsa-project.org,
        vbarinov@embeddedalley.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ALSA: ASoc: putting together AT91SAM9260 and TLV320AIC3X
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au> <4D8B2068.60402@aksignal.cz> <4D8BA47B.8050904@bluewatersys.com>
In-Reply-To: <4D8BA47B.8050904@bluewatersys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this is separeted PATCH for glue AT91SAM9260 and TLV320AIC3X on CDU board.

Depend on: [PATCH 1/2] ALSA: ASoc: TLV320AIC3X: ad SPI and clock on GPIO2 or BCLK
	[PATCH] ALSA: ASoc: new functions snd_soc_7_8_*
	[PATCH] ARCH arm: adding new board: CDU
Kernel version: 2.6.38
Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>

Dne 24.3.2011 21:07, Ryan Mallon napsal(a):
> On 03/24/2011 11:43 PM, Prchal Jiří wrote:
>> Hi,
>> this patch is for example how to put together AT91SAM9260 and TLV320AIC3106 controlled via SPI.
>> It tooks me a lot of time to make it working, so I think it could be helpfull for other people.
>>
>> In original source "snd-soc-afeb9260.c" which I use as example is BIG ERROR:
>> In function "afeb9260_soc_init" is missing call of "atmel_ssc_set_audio(0);". It cause bug "PROBLEM: Asoc driver in
>> 2.6.37.3 for AT91SAM9260 / TLV320AIC3X is broken" which I post some time ago.
> 
> Hi Jiri,
> 
> This patch is actually doing two things: adding board support for a new
> at91sam9260 device and adding the audio glue for the new board. It
> should be split into two patches. Quick review below.
> 
> ~Ryan
> 
I separate it.

>>
>> Depend on: [PATCH 1/2] ALSA: ASoc: TLV320AIC3X: ad SPI and clock on GPIO2 or BCLK
>> Kernel version: 2.6.38
>> Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>
>> ---
>>
>> diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/Kconfig
>> /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/Kconfig
>> --- linux-2.6.38-vanilla/sound/soc/atmel/Kconfig	2011-03-15 02:20:32.000000000 +0100
>> +++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/Kconfig	2011-03-22 09:46:46.751566158 +0100
>> @@ -50,3 +50,11 @@ config SND_AT91_SOC_AFEB9260
>>  	select SND_SOC_TLV320AIC23
>>  	help
>>  	  Say Y here to support sound on AFEB9260 board.
>> +
>> +config SND_AT91_SOC_CDU
>> +	tristate "SoC Audio support for CDU board"
>> +	depends on ARCH_AT91 && MACH_CDU && SND_ATMEL_SOC
>> +	select SND_ATMEL_SOC_SSC
>> +	select SND_SOC_TLV320AIC3X
>> +	help
>> +	  Say Y here to support sound on CDU board.
>> diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/Makefile
>> /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/Makefile
>> --- linux-2.6.38-vanilla/sound/soc/atmel/Makefile	2011-03-15 02:20:32.000000000 +0100
>> +++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/Makefile	2011-03-16 09:26:17.000000000 +0100
>> @@ -14,3 +14,4 @@ snd-soc-playpaq-objs := playpaq_wm8510.o
>>  obj-$(CONFIG_SND_AT91_SOC_SAM9G20_WM8731) += snd-soc-sam9g20-wm8731.o
>>  obj-$(CONFIG_SND_AT32_SOC_PLAYPAQ) += snd-soc-playpaq.o
>>  obj-$(CONFIG_SND_AT91_SOC_AFEB9260) += snd-soc-afeb9260.o
>> +obj-$(CONFIG_SND_AT91_SOC_CDU) += snd-soc-cdu.o
>> diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/snd-soc-cdu.c
>> /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/snd-soc-cdu.c
>> --- linux-2.6.38-vanilla/sound/soc/atmel/snd-soc-cdu.c	1970-01-01 01:00:00.000000000 +0100
>> +++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/sound/soc/atmel/snd-soc-cdu.c	2011-03-24 09:27:55.404367652 +0100
>> @@ -0,0 +1,264 @@
>> +/*
>> + * snd-soc-cdu  --  SoC audio for AT91SAM9260-based
>> + * 			AKsignal CDU board.
>> + *
>> + *  Copyright (C) 2005 SAN People
>> + *  Copyright (C) 2008 Atmel
>> + *  Copyright (C) 2011 AK signal Brno
>> + *
>> + * Authors: Sedji Gaouaou <sedji.gaouaou@atmel.com>
>> + *          Jiri Prchal <jiri.prchal@aksignal.cz>
>> + *
>> + * Based on ati_b1_wm8731.c by:
>> + * Frank Mandarino <fmandarino@endrelia.com>
>> + * Copyright 2006 Endrelia Technologies Inc.
>> + * Based on corgi.c by:
>> + * Copyright 2005 Wolfson Microelectronics PLC.
>> + * Copyright 2005 Openedhand Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/kernel.h>
>> +#include <linux/clk.h>
>> +#include <linux/timer.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/i2c.h>
>> +
>> +#include <linux/atmel-ssc.h>
>> +#include <sound/core.h>
>> +#include <sound/pcm.h>
>> +#include <sound/pcm_params.h>
>> +#include <sound/soc.h>
>> +
>> +#include <asm/mach-types.h>
>> +#include <mach/hardware.h>
>> +#include <mach/gpio.h>
> 
> Note sure you need all of these includes. linux/interrupt.h,
> linux/moduleparam.h, linux/timer.h and mach/gpio.h at least appear to be
> uneccessary.
Cleaned up.

> 
>> +
>> +#include "../codecs/tlv320aic3x.h"
>> +#include "atmel-pcm.h"
>> +#include "atmel_ssc_dai.h"
>> +
>> +struct {
>> +	unsigned int channels;
>> +	snd_pcm_format_t format;
>> +	unsigned int rate;
>> +	unsigned int codecclk;
>> +	unsigned int cmrdiv;
>> +	unsigned int period;
>> +} cdu_audio[] = {
>> +	/* 16 bit stereo modes */
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 8000, 2096000, 25, 130,},
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 16000, 2496000, 21, 77,},
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 32000, 2496000, 21, 38,},
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 48000, 2016000, 26, 20,},
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 96000, 4032000, 13, 20,},
>> +
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 11025, 2381400, 22, 107,},
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 22050, 2381400, 22, 53,},
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 44100, 2381400, 22, 26,},
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 88200, 4762800, 11, 26,},
>> +
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 11520, 2626560, 20, 113,},
>> +	{2, SNDRV_PCM_FORMAT_S16_LE, 23040, 2626560, 20, 56,},
> 
> Can these be calculated rather than using a table? The first two values
> probably don't need to be in the table since they are always the same.
Explained in new comment why it is table. I made the table smaller.

> 
>> +
>> +};
>> +
>> +static int cdu_hw_params(struct snd_pcm_substream *substream, struct snd_pcm_hw_params *params)
>> +{
>> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
>> +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
>> +	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
>> +	int ret;
>> +	int i, found = 0;
>> +	snd_pcm_format_t format = params_format(params);
>> +	unsigned int rate = params_rate(params);
>> +	unsigned int channels = params_channels(params);
>> +
>> +	/* set codec DAI configuration */
>> +	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
> 
> Long lines should be broken to fit inside 80 characters.
OK.

> 
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* set cpu DAI configuration */
>> +	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* find the correct audio parameters */
>> +	for (i = 0; i < ARRAY_SIZE(cdu_audio); i++) {
>> +		if (rate == cdu_audio[i].rate &&
>> +		    format == cdu_audio[i].format &&
>> +		    channels == cdu_audio[i].channels) {
>> +			found = 1;
>> +			break;
>> +		}
>> +	}
>> +	if (!found)
>> +		return -EINVAL;
> 
> Should maybe do this before doing the dai_set_fmt's since we only
> support some modes. Also:
> 
> 	/* Only support 2 channel S16_LE */
> 	if (channels != 2 || format != SNDRV_PCM_FORMAT_S16_LE)
> 		return -EINVAL;
> 
> 	/* Check rate support */
> 	for (i = 0; i < ARRAY_SIZE(cdc_audio); i++)
> 		if (rate == cdc_audio[i].rate) {
> 			found = 1;
> 			break;
> 		}
> 	if (!found)
> 		return -EINVAL;
> 
OK.

>> +
>> +	/* Set the codec system clock for DAC and ADC */
>> +	ret = snd_soc_dai_set_sysclk(codec_dai, CLKIN_BCLK, cdu_audio[i].codecclk, SND_SOC_CLOCK_IN);
>> +	if (ret < 0) {
>> +		printk(KERN_ERR "can't set codec system clock\n");
> 
> You should, I think, be able to do:
> 
> 	struct device *dev = rtd->card->dev;
> 
> 	dev_err(dev, "can't set codec system clock\n");
> 
> Same goes for other printks.
> 
OK.

>> +		return ret;
>> +	}
>> +
>> +	/* Set the cpu clock dividers to BCLK */
>> +	ret = snd_soc_dai_set_clkdiv(cpu_dai, ATMEL_SSC_CMR_DIV, cdu_audio[i].cmrdiv);
>> +	ret |= snd_soc_dai_set_clkdiv(cpu_dai, ATMEL_SSC_TCMR_PERIOD, cdu_audio[i].period);
>> +	ret |= snd_soc_dai_set_clkdiv(cpu_dai, ATMEL_SSC_RCMR_PERIOD, cdu_audio[i].period);
>> +	if (ret < 0) {
>> +		printk(KERN_ERR "can't set cpu system clock\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static struct snd_soc_ops cdu_ops = {
>> +	.hw_params = cdu_hw_params,
>> +};
>> +
>> +static const struct snd_soc_dapm_widget cdu_dapm_widgets[] = {
>> +	SND_SOC_DAPM_HP("Headphone Jack", NULL),
>> +	SND_SOC_DAPM_LINE("Line Out", NULL),
>> +	SND_SOC_DAPM_MIC("Mic Jack", NULL),
>> +	SND_SOC_DAPM_LINE("Line In", NULL),
>> +};
>> +
>> +static const struct snd_soc_dapm_route intercon[] = {
>> +	/* Headphone connected to HPLOUT, HPROUT */
>> +	{"Headphone Jack", NULL, "HPLOUT"},
>> +	{"Headphone Jack", NULL, "HPROUT"},
>> +
>> +	/* Line Out connected to LLOUT, RLOUT */
>> +	{"Line Out", NULL, "LLOUT"},
>> +	{"Line Out", NULL, "RLOUT"},
>> +
>> +	/* Mic connected to (MIC3L | MIC3R) */
>> +	{"MIC3L", NULL, "Mic Bias 2V"},
>> +	{"MIC3R", NULL, "Mic Bias 2V"},
>> +	{"Mic Bias 2V", NULL, "Mic Jack"},
>> +
>> +	/* Line In connected to (LINE1L | LINE2L), (LINE1R | LINE2R) */
>> +	{"LINE1L", NULL, "Line In"},
>> +	{"LINE2L", NULL, "Line In"},
>> +	{"LINE1R", NULL, "Line In"},
>> +	{"LINE2R", NULL, "Line In"},
>> +};
>> +
>> +/*
>> + * Logic for a aic3x as connected on a cdu board.
>> + */
>> +static int cdu_aic3x_init(struct snd_soc_pcm_runtime *rtd)
>> +{
>> +	struct snd_soc_codec *codec = rtd->codec;
>> +	struct snd_soc_dai *codec_dai = rtd->codec_dai;
>> +	struct snd_soc_dapm_context *dapm = &codec->dapm;
>> +	int ret;
>> +
>> +	printk(KERN_DEBUG "cdu_aic3x: cdu_aic3x_init called\n");
> 
> Is this line really needed?
> 
NO, removed.

>> +
>> +	/* Add specific widgets */
>> +	snd_soc_dapm_new_controls(dapm, cdu_dapm_widgets,
>> +				  ARRAY_SIZE(cdu_dapm_widgets));
>> +	/* Set up specific audio path interconnects */
>> +	snd_soc_dapm_add_routes(dapm, intercon, ARRAY_SIZE(intercon));
>> +
>> +	/* always connected */
>> +	snd_soc_dapm_enable_pin(dapm, "Headphone Jack");
>> +	snd_soc_dapm_enable_pin(dapm, "Line Out");
>> +	snd_soc_dapm_enable_pin(dapm, "Mic Jack");
>> +	snd_soc_dapm_enable_pin(dapm, "Line In");
>> +
>> +	snd_soc_dapm_sync(dapm);
> 
> IIRC, you no longer need to explicitly call snd_soc_dapm_enable_pin and
> snd_soc_dapm_sync. Somebody else can probably shed more light on this.
> 
Removed.

>> +
>> +	return 0;
>> +}
>> +
>> +static struct snd_soc_dai_link cdu_dai = {
>> +	.name		= "TLV320AIC3106",
>> +	.stream_name	= "PCM",
>> +	.cpu_dai_name	= "atmel-ssc-dai.0",
>> +	.codec_dai_name	= "tlv320aic3x-hifi",
>> +	.init = cdu_aic3x_init,
> 
> Tab-delimiting got messed here.
> 
OK.

>> +	.platform_name	= "atmel-pcm-audio",
>> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>> +	.codec_name	= "tlv320aic3x-codec.0-001b",
>> +#endif
>> +#if defined(CONFIG_SPI_MASTER)
>> +	.codec_name	= "spi1.3",
>> +#endif
> 
> If both CONFIG_I2C and CONFIG_SPI_MASTER are set then you will have a
> broken build. Which one does the CDU board use?
> 
Since CDU use only SPI the I2C option removed.

>> +	.ops		= &cdu_ops,
>> +};
>> +
>> +static struct snd_soc_card snd_soc_cdu = {
>> +	.name		= "TLV320AIC3106",
>> +	.dai_link	= &cdu_dai,
>> +	.num_links	= 1,
>> +};
>> +
>> +static struct platform_device *cdu_snd_device;
>> +
>> +static int __init cdu_init(void)
>> +{
>> +	struct clk *pllb;
> 
> Remove this line, pllb is never used in this function.
> 
OK.

>> +	int ret;
>> +
>> +	ret = atmel_ssc_set_audio(0);
>> +	if (ret != 0) {
> 
> Nitpick. Just if (ret) is fine.
> 
OK.

>> +		pr_err("Failed to set SSC 0 for audio: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	cdu_snd_device = platform_device_alloc("soc-audio", -1);
>> +	if (!cdu_snd_device) {
>> +		printk(KERN_ERR "ASoC: Platform device allocation failed\n");
>> +		ret = -ENOMEM;
>> +	}
>> +
>> +	platform_set_drvdata(cdu_snd_device, &snd_soc_cdu);
>> +
>> +	ret = platform_device_add(cdu_snd_device);
>> +	if (ret) {
>> +		printk(KERN_ERR "ASoC: Platform device allocation failed\n");
> 
> Use pr_err to be consistent.
> 
OK.

>> +		goto err_device_add;
>> +	}
>> +
>> +	return ret;
>> +
>> +err_device_add:
>> +	platform_device_put(cdu_snd_device);
>> +err:
>> +	return ret;
>> +}
>> +
>> +static void __exit cdu_exit(void)
>> +{
>> +	platform_device_unregister(cdu_snd_device);
>> +	cdu_snd_device = NULL;
> 
> I don't think you need to set cdu_snd_device to NULL here.
> 
OK.

>> +}
>> +
>> +module_init(cdu_init);
>> +module_exit(cdu_exit);
>> +
>> +/* Module information */
>> +MODULE_AUTHOR("Jiri Prchal <jiri.prchal@aksignal.cz>");
>> +MODULE_DESCRIPTION("ALSA SoC CDU_AIC3X");
>> +MODULE_LICENSE("GPL");
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/Kconfig
linux-2.6.38-patch/sound/soc/atmel/Kconfig
--- linux-2.6.38-vanilla/sound/soc/atmel/Kconfig	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/sound/soc/atmel/Kconfig	2011-03-22 09:46:46.751566158 +0100
@@ -50,3 +50,11 @@ config SND_AT91_SOC_AFEB9260
 	select SND_SOC_TLV320AIC23
 	help
 	  Say Y here to support sound on AFEB9260 board.
+
+config SND_AT91_SOC_CDU
+	tristate "SoC Audio support for CDU board"
+	depends on ARCH_AT91 && MACH_CDU && SND_ATMEL_SOC
+	select SND_ATMEL_SOC_SSC
+	select SND_SOC_TLV320AIC3X
+	help
+	  Say Y here to support sound on CDU board.
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/Makefile
linux-2.6.38-patch/sound/soc/atmel/Makefile
--- linux-2.6.38-vanilla/sound/soc/atmel/Makefile	2011-03-15 02:20:32.000000000 +0100
+++ linux-2.6.38-patch/sound/soc/atmel/Makefile	2011-03-16 09:26:17.000000000 +0100
@@ -14,3 +14,4 @@ snd-soc-playpaq-objs := playpaq_wm8510.o
 obj-$(CONFIG_SND_AT91_SOC_SAM9G20_WM8731) += snd-soc-sam9g20-wm8731.o
 obj-$(CONFIG_SND_AT32_SOC_PLAYPAQ) += snd-soc-playpaq.o
 obj-$(CONFIG_SND_AT91_SOC_AFEB9260) += snd-soc-afeb9260.o
+obj-$(CONFIG_SND_AT91_SOC_CDU) += snd-soc-cdu.o
diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/atmel/snd-soc-cdu.c
linux-2.6.38-patch/sound/soc/atmel/snd-soc-cdu.c
--- linux-2.6.38-vanilla/sound/soc/atmel/snd-soc-cdu.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-patch/sound/soc/atmel/snd-soc-cdu.c	2011-03-25 13:42:07.545051043 +0100
@@ -0,0 +1,259 @@
+/*
+ * snd-soc-cdu  --  SoC audio for AT91SAM9260-based
+ * 			AKsignal CDU board.
+ *
+ *  Copyright (C) 2005 SAN People
+ *  Copyright (C) 2008 Atmel
+ *  Copyright (C) 2011 AK signal Brno
+ *
+ * Authors: Sedji Gaouaou <sedji.gaouaou@atmel.com>
+ *          Jiri Prchal <jiri.prchal@aksignal.cz>
+ *
+ * Based on ati_b1_wm8731.c by:
+ * Frank Mandarino <fmandarino@endrelia.com>
+ * Copyright 2006 Endrelia Technologies Inc.
+ * Based on corgi.c by:
+ * Copyright 2005 Wolfson Microelectronics PLC.
+ * Copyright 2005 Openedhand Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+
+#include <linux/atmel-ssc.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include <asm/mach-types.h>
+#include <mach/hardware.h>
+
+#include "../codecs/tlv320aic3x.h"
+#include "atmel-pcm.h"
+#include "atmel_ssc_dai.h"
+
+/*
+ * Table of supported rates
+ * with their clock divider (cmrdiv) and number clock in frame (period + 1 * 2),
+ * codecclk sould be integer multiple of sample rate even if it is not exact true
+ * to avoid data on SSC underrun / overrun -
+ * CPU can not generate clock as fine as CODEC.
+ */
+struct {
+	unsigned int rate;
+	unsigned int codecclk;
+	unsigned int cmrdiv;
+	unsigned int period;
+} cdu_audio[] = {
+	{8000, 2096000, 25, 130,},
+	{16000, 2496000, 21, 77,},
+	{32000, 2496000, 21, 38,},
+	{48000, 2016000, 26, 20,},
+	{96000, 4032000, 13, 20,},
+
+	{11025, 2381400, 22, 107,},
+	{22050, 2381400, 22, 53,},
+	{44100, 2381400, 22, 26,},
+	{88200, 4762800, 11, 26,},
+
+	/* special rates for serial line transfer */
+	{11520, 2626560, 20, 113,},
+	{23040, 2626560, 20, 56,},
+	{46080, 2764800, 19, 29,},
+};
+
+static int cdu_hw_params(struct snd_pcm_substream *substream,
+			 struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	struct device *dev = rtd->card->dev;
+	int ret;
+	int i, found = 0;
+
+	/* set codec DAI configuration */
+	ret = snd_soc_dai_set_fmt(codec_dai,
+				  SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+				  SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	/* set cpu DAI configuration */
+	ret = snd_soc_dai_set_fmt(cpu_dai,
+				  SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+				  SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	/* Only support 1 or 2 channel S16_LE */
+	if ((params_channels(params) != 1 && params_channels(params) != 2) ||
+	   params_format(params) != SNDRV_PCM_FORMAT_S16_LE)
+		return -EINVAL;
+
+	/* Check rate support */
+	for (i = 0; i < ARRAY_SIZE(cdu_audio); i++)
+		if (params_rate(params) == cdu_audio[i].rate) {
+			found = 1;
+			break;
+		}
+	if (!found)
+		return -EINVAL;
+
+	/* Set the codec system clock for DAC and ADC */
+	ret = snd_soc_dai_set_sysclk(codec_dai,
+				     CLKIN_BCLK, cdu_audio[i].codecclk,
+				     SND_SOC_CLOCK_IN);
+	if (ret < 0) {
+		dev_err(dev, "can't set codec system clock\n");
+		return ret;
+	}
+
+	/* Set the cpu clock dividers to BCLK */
+	ret = snd_soc_dai_set_clkdiv(cpu_dai,
+				     ATMEL_SSC_CMR_DIV, cdu_audio[i].cmrdiv);
+	ret |= snd_soc_dai_set_clkdiv(cpu_dai,
+				      ATMEL_SSC_TCMR_PERIOD,
+				      cdu_audio[i].period);
+	ret |= snd_soc_dai_set_clkdiv(cpu_dai,
+				      ATMEL_SSC_RCMR_PERIOD,
+				      cdu_audio[i].period);
+	if (ret < 0) {
+		dev_err(dev, "can't set cpu system clock\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct snd_soc_ops cdu_ops = {
+	.hw_params = cdu_hw_params,
+};
+
+static const struct snd_soc_dapm_widget cdu_dapm_widgets[] = {
+	SND_SOC_DAPM_HP("Headphone Jack", NULL),
+	SND_SOC_DAPM_LINE("Line Out", NULL),
+	SND_SOC_DAPM_MIC("Mic Jack", NULL),
+	SND_SOC_DAPM_LINE("Line In", NULL),
+};
+
+static const struct snd_soc_dapm_route intercon[] = {
+	/* Headphone connected to HPLOUT, HPROUT */
+	{"Headphone Jack", NULL, "HPLOUT"},
+	{"Headphone Jack", NULL, "HPROUT"},
+
+	/* Line Out connected to LLOUT, RLOUT */
+	{"Line Out", NULL, "LLOUT"},
+	{"Line Out", NULL, "RLOUT"},
+
+	/* Mic connected to (MIC3L | MIC3R) */
+	{"MIC3L", NULL, "Mic Bias 2V"},
+	{"MIC3R", NULL, "Mic Bias 2V"},
+	{"Mic Bias 2V", NULL, "Mic Jack"},
+
+	/* Line In connected to (LINE1L | LINE2L), (LINE1R | LINE2R) */
+	{"LINE1L", NULL, "Line In"},
+	{"LINE2L", NULL, "Line In"},
+	{"LINE1R", NULL, "Line In"},
+	{"LINE2R", NULL, "Line In"},
+};
+
+/*
+ * Logic for a aic3x as connected on a cdu board.
+ */
+static int cdu_aic3x_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_codec *codec = rtd->codec;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+	int ret;
+
+	/* Add specific widgets */
+	snd_soc_dapm_new_controls(dapm, cdu_dapm_widgets,
+				  ARRAY_SIZE(cdu_dapm_widgets));
+	/* Set up specific audio path interconnects */
+	snd_soc_dapm_add_routes(dapm, intercon, ARRAY_SIZE(intercon));
+
+	return 0;
+}
+
+static struct snd_soc_dai_link cdu_dai = {
+	.name		= "TLV320AIC3106",
+	.stream_name	= "PCM",
+	.cpu_dai_name	= "atmel-ssc-dai.0",
+	.codec_dai_name	= "tlv320aic3x-hifi",
+	.init		= cdu_aic3x_init,
+	.platform_name	= "atmel-pcm-audio",
+	.codec_name	= "spi1.3",
+	.ops		= &cdu_ops,
+};
+
+static struct snd_soc_card snd_soc_cdu = {
+	.name		= "TLV320AIC3106",
+	.dai_link	= &cdu_dai,
+	.num_links	= 1,
+};
+
+static struct platform_device *cdu_snd_device;
+
+static int __init cdu_init(void)
+{
+	int ret;
+
+	ret = atmel_ssc_set_audio(0);
+	if (ret) {
+		pr_err("Failed to set SSC 0 for audio: %d\n", ret);
+		return ret;
+	}
+
+	cdu_snd_device = platform_device_alloc("soc-audio", -1);
+	if (!cdu_snd_device) {
+		pr_err("ASoC: Platform device allocation failed: %d\n", ret);
+		ret = -ENOMEM;
+	}
+
+	platform_set_drvdata(cdu_snd_device, &snd_soc_cdu);
+
+	ret = platform_device_add(cdu_snd_device);
+	if (ret) {
+		pr_err("ASoC: Platform device adding failed: %d\n", ret);
+		goto err_device_add;
+	}
+
+	return ret;
+
+err_device_add:
+	platform_device_put(cdu_snd_device);
+err:
+	return ret;
+}
+
+static void __exit cdu_exit(void)
+{
+	platform_device_unregister(cdu_snd_device);
+}
+
+module_init(cdu_init);
+module_exit(cdu_exit);
+
+/* Module information */
+MODULE_AUTHOR("Jiri Prchal <jiri.prchal@aksignal.cz>");
+MODULE_DESCRIPTION("ALSA SoC CDU_AIC3X");
+MODULE_LICENSE("GPL");
