Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1HVK7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:59:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42296 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab1HVK7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:59:44 -0400
Message-ID: <4E52368D.4050301@ti.com>
Date: Mon, 22 Aug 2011 11:59:25 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: soc-core: use GFP_KERNEL flag for kmalloc  in snd_soc_cnew
References: <1313809425.4691.3.camel@phoenix>
In-Reply-To: <1313809425.4691.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/11 04:03, Axel Lin wrote:
> GFP_ATOMIC is not needed here, use GFP_KERNEL instead.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/soc-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index ae93aa8..b6d8716 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -1913,7 +1913,7 @@ struct snd_kcontrol *snd_soc_cnew(const struct snd_kcontrol_new *_template,
>  
>  	if (prefix) {
>  		name_len = strlen(long_name) + strlen(prefix) + 2;
> -		name = kmalloc(name_len, GFP_ATOMIC);
> +		name = kmalloc(name_len, GFP_KERNEL);
>  		if (!name)
>  			return NULL;
>  

Acked-by: Liam Girdwood <lrg@ti.com>
