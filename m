Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1ALLLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:11:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46751 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1ALLLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:11:09 -0500
Subject: Re: [PATCH] ASoC: Fix parameter for soc_unregister_ac97_dai_link
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
In-Reply-To: <1294797775.20409.4.camel@mola>
References: <1294797775.20409.4.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 11:11:04 +0000
Message-ID: <1294830664.3303.85.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 10:02 +0800, Axel Lin wrote:
> soc_unregister_ac97_dai_link takes a pointer to a codec.
> 
> Reported-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: stable@kernel.org  [2.6.37]
> ---
>  sound/soc/soc-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index 85b7d54..e061ece 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -1623,7 +1623,7 @@ static void snd_soc_instantiate_card(struct snd_soc_card *card)
>  		if (ret < 0) {
>  			printk(KERN_ERR "asoc: failed to register AC97 %s\n", card->name);
>  			while (--i >= 0)
> -				soc_unregister_ac97_dai_link(&card->rtd[i]);
> +				soc_unregister_ac97_dai_link(card->rtd[i].codec);
>  			goto probe_dai_err;
>  		}
>  	}

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

