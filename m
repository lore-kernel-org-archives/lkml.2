Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab2ISRGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:06:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab2ISRGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:06:35 -0400
Date: Wed, 19 Sep 2012 10:06:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH 20/24] input: rpcmouse: use __iomem pointers for MMIO
Message-ID: <20120919170630.GC16286@core.coreip.homeip.net>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-21-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347658492-11608-21-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:34:48PM +0200, Arnd Bergmann wrote:
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  drivers/input/mouse/rpcmouse.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/mouse/rpcmouse.c b/drivers/input/mouse/rpcmouse.c
> index 272dedd..21c60fe 100644
> --- a/drivers/input/mouse/rpcmouse.c
> +++ b/drivers/input/mouse/rpcmouse.c
> @@ -42,7 +42,7 @@ static irqreturn_t rpcmouse_irq(int irq, void *dev_id)
>  
>  	x = (short) iomd_readl(IOMD_MOUSEX);
>  	y = (short) iomd_readl(IOMD_MOUSEY);
> -	b = (short) (__raw_readl(0xe0310000) ^ 0x70);
> +	b = (short) (__raw_readl(IOMEM(0xe0310000)) ^ 0x70);
>  
>  	dx = x - rpcmouse_lastx;
>  	dy = y - rpcmouse_lasty;
> -- 
> 1.7.10
> 

-- 
Dmitry
