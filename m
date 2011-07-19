Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1GSMjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 08:39:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36632 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1GSMjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 08:39:00 -0400
Message-ID: <4E257ACD.6080608@ru.mvista.com>
Date: Tue, 19 Jul 2011 16:38:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH] gpio/mxc/mxs: fix build error introduced by the reanming
 of irq_gc_ack()
References: <1311046444-25423-1-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1311046444-25423-1-git-send-email-shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-07-2011 7:34, Shawn Guo wrote:

> The following commit renames irq_gc_ack() to irq_gc_ack_set_bit(),
> and makes gpio-mxc and gpio-mxs fail to build.

>    659fb32d1b67476f4ade25e9ea0e2642a5b9c4b5
>    genirq: replace irq_gc_ack() with {set,clr}_bit variants (fwd)

> Signed-off-by: Shawn Guo<shawn.guo@linaro.org>
> ---
> The build error is being seen on linux-next.

>   drivers/gpio/gpio-mxc.c |    2 +-
>   drivers/gpio/gpio-mxs.c |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
> index 89fda58..4a46fbe 100644
> --- a/drivers/gpio/gpio-mxc.c
> +++ b/drivers/gpio/gpio-mxc.c
> @@ -297,7 +297,7 @@ static void __init mxc_gpio_init_gc(struct mxc_gpio_port *port)
>   	gc->private = port;
>
>   	ct = gc->chip_types;
> -	ct->chip.irq_ack = irq_gc_ack,
> +	ct->chip.irq_ack = irq_gc_ack_set_bit,

    There should be semicolon rathern than comma at the end.

>   	ct->chip.irq_mask = irq_gc_mask_clr_bit;
>   	ct->chip.irq_unmask = irq_gc_mask_set_bit;
>   	ct->chip.irq_set_type = gpio_set_irq_type;
> diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
> index d8cafba..88f8506 100644
> --- a/drivers/gpio/gpio-mxs.c
> +++ b/drivers/gpio/gpio-mxs.c
> @@ -156,7 +156,7 @@ static void __init mxs_gpio_init_gc(struct mxs_gpio_port *port)
>   	gc->private = port;
>
>   	ct = gc->chip_types;
> -	ct->chip.irq_ack = irq_gc_ack,
> +	ct->chip.irq_ack = irq_gc_ack_set_bit,

    Same here.

WBR, Sergei
