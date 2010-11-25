Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0KYKrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:47:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58166 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0KYKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:47:00 -0500
Subject: Re: [PATCH] ASoC: davinci-vcif - fix a memory leak
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jhnikula@gmail.com>, alsa-devel@alsa-project.org
In-Reply-To: <1290655994.30158.1.camel@mola>
References: <1290655994.30158.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 10:46:55 +0000
Message-ID: <1290682015.3302.12.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 11:33 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/davinci/davinci-vcif.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
> index fb4cc1e..9d2afcc 100644
> --- a/sound/soc/davinci/davinci-vcif.c
> +++ b/sound/soc/davinci/davinci-vcif.c
> @@ -247,7 +247,10 @@ fail:
>  
>  static int davinci_vcif_remove(struct platform_device *pdev)
>  {
> +	struct davinci_vcif_dev *davinci_vcif_dev = dev_get_drvdata(&pdev->dev);
> +
>  	snd_soc_unregister_dai(&pdev->dev);
> +	kfree(davinci_vcif_dev);
>  
>  	return 0;
>  }

Acked-by: Liam Girdwood <lrg@slimlogic.o.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

