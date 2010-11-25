Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0KYKsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:48:30 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62187 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0KYKs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:48:27 -0500
Subject: Re: [PATCH] ASoC: Call snd_soc_unregister_dais instead of
 snd_soc_unregister_dai in sh4_soc_dai_remove
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Manuel Lauss <mano@roarinelk.homelinux.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290677035.1928.3.camel@mola>
References: <1290677035.1928.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 10:48:23 +0000
Message-ID: <1290682103.3302.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 17:23 +0800, Axel Lin wrote:
> We call snd_soc_register_dais() in sh4_soc_dai_probe(),
> thus we should call snd_soc_unregister_dais() in sh4_soc_dai_remove().
> 
> Otherwise, we got "too many arguments to function 'snd_soc_unregister_dai'"
> error message.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/sh/ssi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/sh/ssi.c b/sound/soc/sh/ssi.c
> index 40bbdf1..05192d9 100644
> --- a/sound/soc/sh/ssi.c
> +++ b/sound/soc/sh/ssi.c
> @@ -387,7 +387,7 @@ static int __devinit sh4_soc_dai_probe(struct platform_device *pdev)
>  
>  static int __devexit sh4_soc_dai_remove(struct platform_device *pdev)
>  {
> -	snd_soc_unregister_dai(&pdev->dev, ARRAY_SIZE(sh4_ssi_dai));
> +	snd_soc_unregister_dais(&pdev->dev, ARRAY_SIZE(sh4_ssi_dai));
>  	return 0;
>  }
>  

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

