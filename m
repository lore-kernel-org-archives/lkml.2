Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab1CCIep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:34:45 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:50833 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab1CCIeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:34:44 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Xuetao Guan'" <epip.guan@gmail.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>
References: <20110303115210.b0e8786b.sfr@canb.auug.org.au>
In-Reply-To: <20110303115210.b0e8786b.sfr@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the unicore32 tree with the i.MX tree
Date: Thu, 3 Mar 2011 16:33:08 +0800
Message-ID: <021601cbd97d$a0cefc10$e26cf430$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIejF6O3PRpazwgZqc2b94OzUkSzJN14jXQ
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-next-owner@vger.kernel.org [mailto:linux-next-owner@vger.kernel.org] On Behalf Of Stephen Rothwell
> Sent: Thursday, March 03, 2011 8:52 AM
> To: Xuetao Guan
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; GuanXuetao; Sascha Hauer
> Subject: linux-next: manual merge of the unicore32 tree with the i.MX tree
> 
> Hi Xuetao,
> 
> Today's linux-next merge of the unicore32 tree got a conflict in
> drivers/video/Kconfig between commit
> 657df5cdfd525648a04b3db69eaa1ba8eb1baf87 ("video: Add i.MX23/28
> framebuffer driver") from the i.MX tree and commit
> a336d8ba89b5afe129cb9178f26216b22d6beb63 ("unicore32 machine related: add
> frame buffer driver for pkunity-v3 soc") from the unicore32 tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.
Thanks.
It looks good to me.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/video/Kconfig
> index 8a2f8cf,ec55a87..0000000
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@@ -2320,15 -2365,17 +2320,26 @@@ config FB_JZ474
>   	help
>   	  Framebuffer support for the JZ4740 SoC.
> 
>  +config FB_MXS
>  +	tristate "MXS LCD framebuffer support"
>  +	depends on FB && ARCH_MXS
>  +	select FB_CFB_FILLRECT
>  +	select FB_CFB_COPYAREA
>  +	select FB_CFB_IMAGEBLIT
>  +	help
>  +	  Framebuffer support for the MXS SoC.
>  +
> + config FB_PUV3_UNIGFX
> + 	tristate "PKUnity v3 Unigfx framebuffer support"
> + 	depends on FB && UNICORE32 && ARCH_PUV3
> + 	select FB_SYS_FILLRECT
> + 	select FB_SYS_COPYAREA
> + 	select FB_SYS_IMAGEBLIT
> + 	select FB_SYS_FOPS
> + 	help
> + 	  Choose this option if you want to use the Unigfx device as a
> + 	  framebuffer device. Without the support of PCI & AGP.
> +
>   source "drivers/video/omap/Kconfig"
>   source "drivers/video/omap2/Kconfig"
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

