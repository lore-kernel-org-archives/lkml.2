Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0KXId1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:33:27 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59262 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0KXIdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UykkfJXWn/kOpZrngYUT+TXYo5gGGmqgxynOG/EvYtruQAOJER6F2kmfvNPqBOwhgY
         cLo/W5FxUOSrTJUGhUi2PVRKjkGehjml571lnIboM4tKAE9XHvkWMgKU4JEFcMOrgXiC
         NlxWiCDc80+8HUZAnHU8RbTbkILHde2ydLvPQ=
Date: Wed, 24 Nov 2010 10:33:38 +0200
From: Jarkko Nikula <jhnikula@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] ASoC: Return proper error for omap3pandora_soc_init
Message-Id: <20101124103338.76d4b5f5.jhnikula@gmail.com>
In-Reply-To: <1290583248.20639.1.camel@mola>
References: <1290583248.20639.1.camel@mola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010 15:20:48 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Return PTR_ERR(omap3pandora_dac_reg) instead of 0 if regulator_get failed.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/omap/omap3pandora.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/omap/omap3pandora.c b/sound/soc/omap/omap3pandora.c
> index bff9864..8047c52 100644
> --- a/sound/soc/omap/omap3pandora.c
> +++ b/sound/soc/omap/omap3pandora.c
> @@ -307,6 +307,7 @@ static int __init omap3pandora_soc_init(void)
>  		pr_err(PREFIX "Failed to get DAC regulator from %s: %ld\n",
>  			dev_name(&omap3pandora_snd_device->dev),
>  			PTR_ERR(omap3pandora_dac_reg));
> +		ret = PTR_ERR(omap3pandora_dac_reg);
>  		goto fail3;
>  	}

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
