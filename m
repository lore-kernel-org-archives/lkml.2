Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1BKSvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:51:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62662 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab1BKSvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:51:48 -0500
Message-ID: <4D5584EC.4070506@mvista.com>
Date: Fri, 11 Feb 2011 21:50:20 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com, sachi@mistralsolutions.com,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 11/13] da850: pruss SUART board specific additions.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-12-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1297435892-28278-12-git-send-email-subhasish@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subhasish Ghosh wrote:

> This patch adds the pruss SUART pin mux and registers the device
> with the pruss mfd driver.

> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c |   36 +++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index f9c38f8..3858516 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
[...]
> @@ -1085,6 +1104,17 @@ static int __init da850_evm_setup_pruss_can(void)
>  	return ret;
>  }
>  
> +static struct da850_evm_pruss_suart_data suart_data = {
> +	.version	= 1,
> +	.resource	= {
> +			.name	= "da8xx_mcasp0_iomem",
> +			.start	= DAVINCI_DA8XX_MCASP0_REG_BASE,
> +			.end	= DAVINCI_DA8XX_MCASP0_REG_BASE +
> +					(SZ_1K * 12) - 1,
> +			.flags	= IORESOURCE_MEM,
> +		},
> +};
> +

    I don't think passing a resource thru platform data is good idea... 
Resources should be bound to the platform device.

WBR, Sergei
