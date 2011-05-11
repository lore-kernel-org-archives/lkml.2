Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1EKQju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:39:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54725 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab1EKPrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:47:43 -0400
Subject: Re: [PATCH -next] ASoC: fix wm8958-dsp2 printk format warnings
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110508094824.b6952ae6.randy.dunlap@oracle.com>
References: <20110505134959.b3761297.sfr@canb.auug.org.au>
	 <20110506161310.54b22b9f.randy.dunlap@oracle.com>
	 <20110508140101.GB15968@opensource.wolfsonmicro.com>
	 <4DC6B8F7.4000302@oracle.com>
	 <20110508160604.GB32214@opensource.wolfsonmicro.com>
	 <20110508094824.b6952ae6.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 15:05:01 +0100
Message-ID: <1305122701.3277.29.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-08 at 09:48 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings in wm8958-dsp2.c:
> 
> sound/soc/codecs/wm8958-dsp2.c:103: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
> sound/soc/codecs/wm8958-dsp2.c:111: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> sound/soc/codecs/wm8958-dsp2.c:144: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  sound/soc/codecs/wm8958-dsp2.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-next-20110505.orig/sound/soc/codecs/wm8958-dsp2.c
> +++ linux-next-20110505/sound/soc/codecs/wm8958-dsp2.c
> @@ -99,7 +99,7 @@ static int wm8958_dsp2_fw(struct snd_soc
>  	len = fw->size - len;
>  	while (len) {
>  		if (len < 12) {
> -			dev_err(codec->dev, "%s short data block of %d\n",
> +			dev_err(codec->dev, "%s short data block of %zd\n",
>  				name, len);
>  			goto err;
>  		}
> @@ -107,7 +107,7 @@ static int wm8958_dsp2_fw(struct snd_soc
>  		memcpy(&data32, data + 4, sizeof(data32));
>  		block_len = be32_to_cpu(data32);
>  		if (block_len + 8 > len) {
> -			dev_err(codec->dev, "%d byte block longer than file\n",
> +			dev_err(codec->dev, "%zd byte block longer than file\n",
>  				block_len);
>  			goto err;
>  		}
> @@ -141,7 +141,7 @@ static int wm8958_dsp2_fw(struct snd_soc
>  		case WM_FW_BLOCK_I:
>  		case WM_FW_BLOCK_A:
>  		case WM_FW_BLOCK_C:
> -			dev_dbg(codec->dev, "%s: %d bytes of %x@%x\n", name,
> +			dev_dbg(codec->dev, "%s: %zd bytes of %x@%x\n", name,
>  				block_len, (data32 >> 24) & 0xff,
>  				data32 & 0xffffff);


Acked-by: Liam Girdwood <lrg@ti.com>

