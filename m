Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0KVHn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:43:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36129 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab0KVHn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:43:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=g+uniK5CZssITRgBKtYbsGz30u0NAk1/GFsAkdF1tO8KOymCPy9BMd4NBpGdWGocgC
         mOlJ6MwJbkdOtcjO7nwIQgYOfOZlirAAZgqttjqaOpEmonn3lFiTQQxUXw6SBw+ZlVgI
         /AA6M2VlhpU9ynE2U1WLdi+gcSiCfiDYgtdCg=
Date: Mon, 22 Nov 2010 09:43:53 +0200
From: Jarkko Nikula <jhnikula@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@freescale.com>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: atmel: test wrong variable
Message-Id: <20101122094353.f76830b5.jhnikula@gmail.com>
In-Reply-To: <1290361216-15166-1-git-send-email-segoon@openwall.com>
References: <1290361216-15166-1-git-send-email-segoon@openwall.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 20:40:14 +0300
Vasiliy Kulikov <segoon@openwall.com> wrote:

> After clk_get() mclk is checked second time instead of pllb check.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile this driver, so it is not tested.
> 
>  sound/soc/atmel/sam9g20_wm8731.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
> index da9c303..68072a2 100644
> --- a/sound/soc/atmel/sam9g20_wm8731.c
> +++ b/sound/soc/atmel/sam9g20_wm8731.c
> @@ -223,7 +223,7 @@ static int __init at91sam9g20ek_init(void)
>  	}
>  
>  	pllb = clk_get(NULL, "pllb");
> -	if (IS_ERR(mclk)) {
> +	if (IS_ERR(pllb)) {
>  		printk(KERN_ERR "ASoC: Failed to get PLLB\n");
>  		ret = PTR_ERR(mclk);

Update also PTR_ERR as otherwise we don't return any error code
(mclk is ok at this point but pllb has an error).

-- 
Jarkko
