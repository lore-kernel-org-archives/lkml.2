Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1I2BdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:33:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33705 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1I2BdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:33:15 -0400
MIME-Version: 1.0
In-Reply-To: <1317218530.8008.4.camel@phoenix>
References: <1317218471.8008.3.camel@phoenix>
	<1317218530.8008.4.camel@phoenix>
Date: Thu, 29 Sep 2011 09:33:14 +0800
Message-ID: <CABqxG0cswfkC9g65PyR9exX+X--Un8veUPS_5qjcZ=hZbfPvUA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: Add BUG() assertion if max98095_get_bq_channel
 returns -EINVAL
From: Dave Young <hidave.darkstar@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:02 PM, Axel Lin <axel.lin@gmail.com> wrote:
> The callers use the return value of max98095_get_bq_channel as array index to
> access max98095->dai[] array.
> Add BUG() assertion for out of bound access of max98095->dai[] array.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/max98095.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
> index 668434d..973c02d 100644
> --- a/sound/soc/codecs/max98095.c
> +++ b/sound/soc/codecs/max98095.c
> @@ -1998,6 +1998,7 @@ static int max98095_get_bq_channel(const char *name)
>                return 0;
>        if (strcmp(name, "Biquad2 Mode") == 0)
>                return 1;
> +       BUG();
>        return -EINVAL;

below better?
BUG_ON(strcmp(name, "Biquad2 Mode"));
return 1;

Or BUG_ON(channel < 0) in caller

>  }
>
> --
> 1.7.4.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
Dave
