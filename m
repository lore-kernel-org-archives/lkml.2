Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0EWInj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 04:43:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56343 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0EWIne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 04:43:34 -0400
Message-ID: <4BF8EA83.4030406@mvista.com>
Date: Sun, 23 May 2010 12:42:43 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>, Ian Jeffray <ian@jeffray.co.uk>
CC: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       Cliff Cai <cliff.cai@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org, stable@kernel.org,
       stable-review@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: musb: fix Blackfin building after power updates
References: <1274582948-11499-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1274582948-11499-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mike Frysinger wrote:

> From: Ian Jeffray <ian@jeffray.co.uk>

> The new MUSB power code needs musb_read_txhubport() to return a value (so
> stub it as 0 like the other Blackfin hub funcs).  It also needs new helper
> functions for saving/restoring context,

    No, it doesn't. It was an erratic patch that caused these functions 
to be needed outside OMAPs. I've already submitted a patch fixing this, see:

http://marc.info/?l=linux-usb&m=127427834925805

> so change the apparently unused
> musb_platform_{suspend,resume} to musb_platform_{save,restore}_context in
> the Blackfin code.

    I don't see where you're "changing" them -- and no wonder as I have 
deleted these two unused functions.

> Signed-off-by: Ian Jeffray <ian@jeffray.co.uk>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> Note: this is for 2.6.34.x and 2.6.35
> Note: i believe this is what we want, but Cliff is free to correct me ;)

    No, it's not what we want -- though I'm not Cliff. :-)

>  drivers/usb/musb/blackfin.c  |   12 ++++++++++++
>  drivers/usb/musb/musb_regs.h |    3 ++-
>  2 files changed, 14 insertions(+), 1 deletions(-)

> diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
> index b611420..b5f1d17 100644
> --- a/drivers/usb/musb/blackfin.c
> +++ b/drivers/usb/musb/blackfin.c
> @@ -392,6 +392,18 @@ int __init musb_platform_init(struct musb *musb, void *board_data)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM
> +void musb_platform_save_context(struct musb *musb,
> +			struct musb_context_registers *musb_context)
> +{
> +}
> +
> +void musb_platform_restore_context(struct musb *musb,
> +			struct musb_context_registers *musb_context)
> +{
> +}
> +#endif
> +
>  int musb_platform_exit(struct musb *musb)
>  {
>  
> diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
> index 2442675..5a727c5 100644
> --- a/drivers/usb/musb/musb_regs.h
> +++ b/drivers/usb/musb/musb_regs.h
> @@ -633,8 +633,9 @@ static inline u8  musb_read_txhubaddr(void __iomem *mbase, u8 epnum)
>  	return 0;
>  }
>  
> -static inline void  musb_read_txhubport(void __iomem *mbase, u8 epnum)
> +static inline u8 musb_read_txhubport(void __iomem *mbase, u8 epnum)
>  {
> +	return 0;
>  }
>  
>  #endif /* CONFIG_BLACKFIN */

    Besides, this actually should have been two patches...

WBR, Sergei
