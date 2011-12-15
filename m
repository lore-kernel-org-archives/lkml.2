Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab1LONER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:04:17 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:39393 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1LONEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:04:16 -0500
Message-ID: <4EE9F04C.6080906@atmel.com>
Date: Thu, 15 Dec 2011 14:04:12 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: voice <voice.shen@atmel.com>
CC: linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        JM.Lin@atmel.com, Hong.Xu@atmel.com
Subject: Re: [PATCH] atmel ac97c: using software reset instead hardware reset
 if not available
References: <1322042701-32100-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1322042701-32100-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 11:05 AM, voice :
> Using software reset instead hardware reset if not available

Ping?
Can you please tell me what is the status of this fix? Will it go
upstream for 3.3?

> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>  sound/atmel/ac97c.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
> index 6e5adde..73516f6 100644
> --- a/sound/atmel/ac97c.c
> +++ b/sound/atmel/ac97c.c
> @@ -899,6 +899,10 @@ static void atmel_ac97c_reset(struct atmel_ac97c *chip)
>  		/* AC97 v2.2 specifications says minimum 1 us. */
>  		udelay(2);
>  		gpio_set_value(chip->reset_pin, 1);
> +	} else {
> +		ac97c_writel(chip, MR, AC97C_MR_WRST | AC97C_MR_ENA);
> +		udelay(2);
> +		ac97c_writel(chip, MR, AC97C_MR_ENA);
>  	}
>  }
>  


-- 
Nicolas Ferre
