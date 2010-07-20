Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0GTKc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:32:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42718 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0GTKcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZeuswTBs9eRZ4hfIx03zx+TAoYCLOQ9TAgMUlBqd9maRDyt6pL+Ju3WMpqjxXO/4ye
         MSQrr/8bUl5qrXTbVUk1hF6N9AW3Vodk2L0hggJXpBmhOoMKd9NcrlBzc3dRYnTcESPQ
         BSrhV1bdCWaZG0xf84g6kll5Tg6eyhJ831Aag=
MIME-Version: 1.0
In-Reply-To: <1279162237.29294.4.camel@mola>
References: <1279162147.29294.2.camel@mola> <1279162237.29294.4.camel@mola>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 20 Jul 2010 18:31:43 +0800
Message-ID: <AANLkTim21rRtOWi6MEnh_wAMFimiPMV4YGnDbwo2XqGx@mail.gmail.com>
Subject: Re: [PATCH 1/12] ad1836: fix a memory leak if another ad1836 is 
	registered
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Barry Song <Barry.Song@analog.com>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:50 AM, Axel Lin <axel.lin@gmail.com> wrote:
> ad1836 is allocated in ad1836_spi_probe() but is not freed if ad1836_register()
> return -EINVAL (if another ad1836 is registered).
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Barry Song <21cnbao@gmail.com>

> ---
>  sound/soc/codecs/ad1836.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
> index 2175384..a01006c 100644
> --- a/sound/soc/codecs/ad1836.c
> +++ b/sound/soc/codecs/ad1836.c
> @@ -272,6 +272,7 @@ static int ad1836_register(struct ad1836_priv *ad1836)
>
>        if (ad1836_codec) {
>                dev_err(codec->dev, "Another ad1836 is registered\n");
> +               kfree(ad1836);
>                return -EINVAL;
>        }
>
> --
> 1.5.4.3
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
