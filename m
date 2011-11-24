Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1KXKoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:44:09 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:45468 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1KXKoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:44:07 -0500
Message-ID: <4ECE1FF1.2050707@atmel.com>
Date: Thu, 24 Nov 2011 11:44:01 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: voice <voice.shen@atmel.com>
CC: linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        JM.Lin@atmel.com, Hong.Xu@atmel.com
Subject: Re: [PATCH] atmel ac97c: using software reset instead hardware reset
 if not available
References: <1322042701-32100-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1322042701-32100-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 11:05 AM, voice :
> Using software reset instead hardware reset if not available
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

You may need to sent it to the sound subsystem mailing-list and maintainers.

Anyway, I let you follow this patch... As it is a fixup and will benefit
to existing platforms, I think that it can make its way to mainline
during 3.2 phase.

Best regards,

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
