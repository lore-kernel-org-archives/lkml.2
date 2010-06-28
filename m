Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0F1TLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:11:52 -0400
Received: from fbr02.csee.onr.siteprotect.com ([64.26.60.146]:52868 "EHLO
	fbr02.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482Ab0F1TLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:11:50 -0400
Message-ID: <4C28F3D1.5060806@boundarydevices.com>
Date: Mon, 28 Jun 2010 12:11:13 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       alsa-devel@alsa-project.org, Russell King <linux@arm.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Chaithrika U S <chaithrika@ti.com>, Jaroslav Kysela <perex@perex.cz>,
       linux-arm-kernel@lists.infradead.org,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] ASoC: DaVinci: Added support for cpu clocking I2S
References: <1277707487-3371-1-git-send-email-lamiaposta71@gmail.com>
In-Reply-To: <1277707487-3371-1-git-send-email-lamiaposta71@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020204.4C28F3E1.0061,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raffaele Recalcati wrote:
> +		if (dev->i2s_fast_clock) {
> +			clk_div = 256;
can you have
   f = (freq / params->rate_num) * params->rate_den;
> +			do {
> +				framesize = (freq / (--clk_div)) /
> +					    params->rate_num *
> +					    params->rate_den;
and
				framesize = f / (--clk_div);
> +			} while (((framesize < 33) || (framesize > 4095)) &&
> +				 (clk_div));
> +			clk_div--;
looks like clk_div can go negative here, should the above while say (clk_div > 1)
> +			srgr |= DAVINCI_MCBSP_SRGR_FPER(framesize - 1);
> +		} else {
> +			/* symmetric waveforms */
> +			clk_div = freq / (mcbsp_word_length * 16) /
> +				  params->rate_num * params->rate_den;
> +			srgr |= DAVINCI_MCBSP_SRGR_FPER(mcbsp_word_length *
> +							16 - 1);
> +		}
> +		clk_div &= 0xFF;
> +		srgr |= clk_div;
