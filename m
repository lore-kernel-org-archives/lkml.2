Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1LIIi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:38:59 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50308 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1LIIi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:38:58 -0500
MIME-Version: 1.0
In-Reply-To: <20111207132322.GA18837@opensource.wolfsonmicro.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
	<20111202153401.GX8245@opensource.wolfsonmicro.com>
	<CANKRQniyjT_2Ko=EYmffu3_NzDJQTMm9nY6rUp-DQ70e6AVQpA@mail.gmail.com>
	<20111205183223.GB7467@opensource.wolfsonmicro.com>
	<CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
	<CANKRQnhbBNDjQw5MQGexZAEboC0oHB5QS1LfHo6pDeoeDSwByw@mail.gmail.com>
	<20111207132322.GA18837@opensource.wolfsonmicro.com>
Date: Fri, 9 Dec 2011 17:38:57 +0900
Message-ID: <CANKRQniJR+b1gUwZUUiPoNDKVqU7TCkThLaHL2DFXAF=cARrTA@mail.gmail.com>
Subject: Re: [PATCH v2] soc/lapis: add machine driver
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/7 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> Your above code has no references to dai_fmt.  Have you looked at the
> dai_fmt field in the dai_link structure or at the existing examples of
> its use?

Still I can't understand your saying. Let me clarify.

Firstly, the above "dai_link structure" means below ? If yes, there is
no member "dai_fmt", right ?
697 struct snd_soc_dai_link {
698         /* config - must be set by machine driver */
699         const char *name;                       /* Codec name */
700         const char *stream_name;                /* Stream name */
701         const char *codec_name;         /* for multi-codec */
702         const char *platform_name;      /* for multi-platform */
703         const char *cpu_dai_name;
704         const char *codec_dai_name;
705
706         /* Keep DAI active over suspend */
707         unsigned int ignore_suspend:1;
708
709         /* Symmetry requirements */
710         unsigned int symmetric_rates:1;
711
712         /* codec/machine specific init - e.g. add machine controls */
713         int (*init)(struct snd_soc_pcm_runtime *rtd);
714
715         /* machine stream operations */
716         struct snd_soc_ops *ops;
717

> +     ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
> +                             SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
At the above point, do you mean I shouldn't  set these formats(
SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS)
directly ?

Anyway,let me know your best reference driver obeys your saying about it.

thanks,
tomoya
