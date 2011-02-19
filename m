Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1BSVp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 16:45:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59022 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1BSVp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 16:45:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YEGhRhkc46ZSlrHKuhkyDmHlWFrQz3TVQIqrW1dlfg/O/uz434/szGQDo/cmB9yIfh
         1FmunFST+32SxdCMaIQLvQ2ZdjSMbE9w2f4DxioggCd34MY1GRPoBuSRuiRDvrj2UdyY
         MDdXL6hfkqv46jexnEVnTBEI9qc7sBGGOpWMI=
Date: Sat, 19 Feb 2011 13:45:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dustan Bower <dustan.bower@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Chou <thomas@wytron.com.tw>
Subject: Re: [PATCH] Input: serio: Compile error fix (altera_ps2.c)
Message-ID: <20110219214549.GA4933@core.coreip.homeip.net>
References: <1298145859-10892-1-git-send-email-dustan.bower@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1298145859-10892-1-git-send-email-dustan.bower@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 03:04:19PM -0500, Dustan Bower wrote:
> Fixed compile error, today's linux-next tree:
> 
>   CC [M]  drivers/input/serio/altera_ps2.o
> drivers/input/serio/altera_ps2.c:182:1: error: expected ‘,’ or ‘;’ before ‘extern’
> make[1]: *** [drivers/input/serio/altera_ps2.o] Error 1
> make: *** [_module_drivers/input/serio] Error 2
> 
> Signed-off-by: Dustan Bower <dustan.bower@gmail.com>

Thanks Dustan.

Grant, maybe you could amend the original patch so that we do not
introduce bisection failure point?

> ---
>  drivers/input/serio/altera_ps2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
> index 3fee88b..d363dc4 100644
> --- a/drivers/input/serio/altera_ps2.c
> +++ b/drivers/input/serio/altera_ps2.c
> @@ -178,7 +178,7 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>  static const struct of_device_id altera_ps2_match[] = {
>  	{ .compatible = "ALTR,ps2-1.0", },
>  	{},
> -}
> +};
>  MODULE_DEVICE_TABLE(of, altera_ps2_match);
>  #else /* CONFIG_OF */
>  #define altera_ps2_match NULL
> -- 
> 1.7.4.1
> 

-- 
Dmitry
