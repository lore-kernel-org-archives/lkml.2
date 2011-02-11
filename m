Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1BKS4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:56:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab1BKS4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:56:39 -0500
Message-ID: <4D55860E.3090908@mvista.com>
Date: Fri, 11 Feb 2011 21:55:10 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com, sachi@mistralsolutions.com,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/13] da850: pruss SUART platform specific additions.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-13-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1297435892-28278-13-git-send-email-subhasish@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subhasish Ghosh wrote:

> This patch adds the McASP clock alias.
> The alias is used by the pruss suart driver
> for enabling the McASP PSC.

> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
[...]

> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index e15de72..f1cf605 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -560,7 +560,18 @@ struct platform_device da8xx_pruss_dev = {
>  
>  int __init da8xx_register_pruss(struct da8xx_pruss_devices *pruss_device)
>  {
> +#ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE

    #ifdef's in the function body are generally fromned upon.

> +	int ret;
> +#endif
> +

    This line should have been inside #ifdef...

>  	da8xx_pruss_dev.dev.platform_data = pruss_device;
> +
> +#ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE

    Why not do it before assigning the platform data and avoid extra #ifdef?

> +	ret = clk_add_alias(NULL, "da8xx_pruss_uart.1",
> +	NULL, &da850_mcasp_device.dev);

    This line should be indented more to the right.

> +	if (ret < 0)
> +		return ret;
> +#endif

WBR, Sergei
