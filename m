Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1GAOSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:18:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36345 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab1GAOSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:18:41 -0400
Message-ID: <4E0DD72C.3020209@ti.com>
Date: Fri, 1 Jul 2011 15:18:20 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: wm8731: set the ACTIVE bit if bias ON entered
References: <ccd4b125244271af7978948689cf1dcef37bc06b.1309368631.git.nicolas.ferre@atmel.com> <1309517034-26110-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1309517034-26110-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/11 11:43, Nicolas Ferre wrote:
> Resuming from a suspend/resume cycle, the ACTIVE bit was not set even if a
> stream had actually been processing.
> Setting this bit at entering SND_SOC_BIAS_ON level will ensure this.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Supersed the wrong patch:
> "[PATCH 1/5] ASoC: wm8731: rework power management"
> 
> now based on broonie/sound-2.6 git tree branch: for-3.1.
> 
>  sound/soc/codecs/wm8731.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
> index 2dc964b..ee4ec31 100644
> --- a/sound/soc/codecs/wm8731.c
> +++ b/sound/soc/codecs/wm8731.c
> @@ -453,6 +453,7 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
>  
>  	switch (level) {
>  	case SND_SOC_BIAS_ON:
> +		snd_soc_write(codec, WM8731_ACTIVE, 0x0001);
>  		break;
>  	case SND_SOC_BIAS_PREPARE:
>  		break;


Acked-by: Liam Girdwood <lrg@ti.com>
