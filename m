Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1AMNzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:55:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35462 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756816Ab1AMNzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:55:10 -0500
Date: Thu, 13 Jan 2011 13:55:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: alsa-devel@alsa-project.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Blackfin TDM: fix missed snd_soc_dai_get_drvdata
 update
Message-ID: <20110113135525.GD11840@opensource.wolfsonmicro.com>
References: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:08:19PM -0500, Mike Frysinger wrote:
> One spot was missed in this driver when converting from
> snd_soc_dai.private_data to snd_soc_dai_get_drvdata.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Ccing in Liam - Mike, please remember to CC maintainers on patches - and
dropping the stable lists for now.


> ---
>  sound/soc/blackfin/bf5xx-tdm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/blackfin/bf5xx-tdm.c b/sound/soc/blackfin/bf5xx-tdm.c
> index 1251239..b2cf239 100644
> --- a/sound/soc/blackfin/bf5xx-tdm.c
> +++ b/sound/soc/blackfin/bf5xx-tdm.c
> @@ -210,7 +210,7 @@ static int bf5xx_tdm_set_channel_map(struct snd_soc_dai *dai,
>  #ifdef CONFIG_PM
>  static int bf5xx_tdm_suspend(struct snd_soc_dai *dai)
>  {
> -	struct sport_device *sport = dai->private_data;
> +	struct sport_device *sport = snd_soc_dai_get_drvdata(dai);
>  
>  	if (!dai->active)
>  		return 0;
> -- 
> 1.7.4.rc1
> 
