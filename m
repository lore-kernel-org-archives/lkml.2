Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1BTMjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 07:39:39 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37235 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1BTMji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 07:39:38 -0500
Message-ID: <4D610B3A.5070705@mvista.com>
Date: Sun, 20 Feb 2011 15:38:18 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Anoop P.A" <anoop.pa@gmail.com>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make msp7120_reset generic
References: <1298037329-13683-1-git-send-email-anoop.pa@gmail.com>
In-Reply-To: <1298037329-13683-1-git-send-email-anoop.pa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-02-2011 16:55, Anoop P.A wrote:

> From: Anoop P A<anoop.pa@gmail.com>

> Remove platform dependency code from msp7120 reset code and make it generic.
> Now the code can be reused for other boards running msp71xx family SoC.

> Signed-off-by: Anoop P A<anoop.pa@gmail.com>
[...]

> diff --git a/arch/mips/pmc-sierra/msp71xx/msp_setup.c b/arch/mips/pmc-sierra/msp71xx/msp_setup.c
> index fb37a10..4a6cc0d 100644
> --- a/arch/mips/pmc-sierra/msp71xx/msp_setup.c
> +++ b/arch/mips/pmc-sierra/msp71xx/msp_setup.c
> @@ -18,30 +18,33 @@
>
>   #include<msp_prom.h>
>   #include<msp_regs.h>
> +#include<msp_gpio_macros.h>
>
>   #if defined(CONFIG_PMC_MSP7120_GW)
> -#include<msp_regops.h>
> +	/* GPIO 9 is the 4th GPIO of register 3
> +	 */

    Not clear why you're using a multi-line comment where a single-one line 
one (and not indented) would be enough?

> @@ -78,49 +81,56 @@ void msp7120_reset(void)
>   	/* Wait a bit for the DDRC to settle */
>   	for (i = 0; i < 100000000; i++);
>
> -#if defined(CONFIG_PMC_MSP7120_GW)
> +#if defined MSP_BOARD_RESET_GPIO

    Hm, didn't know that the 'defined' syntax without parens is valid too...

> @@ -141,9 +151,7 @@ void msp_power_off(void)
>
>   void __init plat_mem_setup(void)
>   {
> -	_machine_restart = msp_restart;
> -	_machine_halt = msp_halt;
> -	pm_power_off = msp_power_off;
> +/*TODO: Move mem setup here */

    This line should be indented.

WBR, Sergei
