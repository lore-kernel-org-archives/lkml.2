Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab2HGCHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:07:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34924 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab2HGCHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:07:49 -0400
MIME-Version: 1.0
In-Reply-To: <1343824834.3859.2.camel@phoenix>
References: <1343824834.3859.2.camel@phoenix>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 7 Aug 2012 10:07:27 +0800
X-Google-Sender-Auth: ktUp9aBYRnYziWiwUYyMJL38kgI
Message-ID: <CAK5ve-+dvpQqj1q9QF8nfST0Ff=W7WCO=_jYdGi7gOjsWO+93w@mail.gmail.com>
Subject: Re: [PATCH RFT] leds: lp8788: Fix updating scale configuration bits
To: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 8:40 PM, Axel Lin <axel.lin@gmail.com> wrote:
> We need to do left shift (cfg->num + LP8788_ISINK_SCALE_OFFSET) bits for
> updating scale configuration.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi Milo,
> Current code of updating scale configuration bits looks wrong to me
> because the mask does not match the val.
> I don't have this hardware, can you test this patch?
>

Milo, I think this patch from Axel is reasonable. could you please
take a look at this?

-Bryan

> Thanks,
> Axel
>  drivers/leds/leds-lp8788.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/leds/leds-lp8788.c b/drivers/leds/leds-lp8788.c
> index 53bd136..0ade6eb 100644
> --- a/drivers/leds/leds-lp8788.c
> +++ b/drivers/leds/leds-lp8788.c
> @@ -63,7 +63,7 @@ static int lp8788_led_init_device(struct lp8788_led *led,
>         /* scale configuration */
>         addr = LP8788_ISINK_CTRL;
>         mask = 1 << (cfg->num + LP8788_ISINK_SCALE_OFFSET);
> -       val = cfg->scale << cfg->num;
> +       val = cfg->scale << (cfg->num + LP8788_ISINK_SCALE_OFFSET);
>         ret = lp8788_update_bits(led->lp, addr, mask, val);
>         if (ret)
>                 return ret;
> --
> 1.7.9.5
>
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
