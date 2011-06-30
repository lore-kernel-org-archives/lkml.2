Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1F3ShL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:37:11 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48795 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752131Ab1F3ShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:37:08 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] media: fix radio-sf16fmr2 build when SND is not enabled
Date: Thu, 30 Jun 2011 20:36:49 +0200
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20110630165302.12ee1bd0.sfr@canb.auug.org.au> <20110630103104.0a5b8ce6.randy.dunlap@oracle.com>
In-Reply-To: <20110630103104.0a5b8ce6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106302036.56468.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 June 2011 19:31:04 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_SND is not enabled, radio-sf16fmr2 build fails with:
> 
> ERROR: "snd_tea575x_init" [drivers/media/radio/radio-sf16fmr2.ko] undefined!
> ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-sf16fmr2.ko] undefined!
> 
> so make this driver depend on SND.

I broke this when converting the driver to use common TEA575x code.
Thanks for finding and fixing it.

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/radio/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20110630.orig/drivers/media/radio/Kconfig
> +++ linux-next-20110630/drivers/media/radio/Kconfig
> @@ -201,7 +201,7 @@ config RADIO_SF16FMI
>  
>  config RADIO_SF16FMR2
>  	tristate "SF16FMR2 Radio"
> -	depends on ISA && VIDEO_V4L2
> +	depends on ISA && VIDEO_V4L2 && SND
>  	---help---
>  	  Choose Y here if you have one of these FM radio cards.



-- 
Ondrej Zary
