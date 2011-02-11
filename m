Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab1BKSrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:47:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47001 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab1BKSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:47:03 -0500
Message-ID: <4D5583CF.8010905@mvista.com>
Date: Fri, 11 Feb 2011 21:45:35 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com, sachi@mistralsolutions.com,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 06/13] da850: pruss CAN board specific additions.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-7-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1297435892-28278-7-git-send-email-subhasish@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subhasish Ghosh wrote:

> This patch adds the pruss CAN pin mux and registers the device
> with the pruss mfd driver.

> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
[...]

> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 242d1ed..2ce5536 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1053,8 +1053,43 @@ static __init int da850_evm_init_cpufreq(void)
[...]
>  static struct da8xx_pruss_devices pruss_devices[] = {
> -	{.dev_name = NULL,},
> +	{
> +		.dev_name	= "da8xx_pruss_can",
> +		.pdata		= &can_data,
> +		.pdata_size	= sizeof(can_data),
> +		.setup		= da850_evm_setup_pruss_can,
> +	},
> +	{
> +		.dev_name	= NULL,
> +	},

    No need to explicitly initialize to NULL.

WBR, Sergei
