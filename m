Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1BGL7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:59:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52059 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754054Ab1BGL7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:59:08 -0500
Date: Mon, 7 Feb 2011 11:59:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] ASoC: Samsung: neo1973_gta02: Fix bluetooth DAI
 registration
Message-ID: <20110207115906.GD10564@opensource.wolfsonmicro.com>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
 <1297033463-14577-6-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297033463-14577-6-git-send-email-lars@metafoo.de>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 12:04:22AM +0100, Lars-Peter Clausen wrote:
> This patch fixes two issues with the bluethooth DAI registration:
> * The DAI has to be registered only after the sound device has been added.

This isn't a problem, components in the system can be registered in any
order.

> * Currently the DAI is registered with snd_soc_register_dai which causes it to
>   be named after the device it was registered for. Which is in this case the
>   "soc-audio" device. (Ab)use snd_soc_register_dais which causes the DAI to be
>   named after the DAI driver, which is what we want in this case.

This doesn't tie up with your change which...

> -	/* register bluetooth DAI here */
> -	ret = snd_soc_register_dai(&neo1973_gta02_snd_device->dev, &bt_dai);
> -	if (ret)
> -		goto err_put_device;

> +	/* register bluetooth DAI here */
> +	ret = snd_soc_register_dais(&neo1973_gta02_snd_device->dev, &bt_dai, 1);
>  	if (ret)
> -		goto err_unregister_dai;
> +		goto err_unregister_device;

...uses the same device in both cases and looking briefly at the code
both register functions just use the dev that was passed in.  In any
case, we clearly shouldn't be applying patches which bodge around the
core.
