Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1DZK6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:58:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63198 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1DZK6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:58:54 -0400
Message-ID: <4DB6A509.2010009@mvista.com>
Date: Tue, 26 Apr 2011 14:57:13 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        Kevin Hilman <khilman@ti.com>, sachi@mistralsolutions.com,
        Russell King <linux@arm.linux.org.uk>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 11/11] da850: pruss CAN board specific additions.
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-12-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1303474109-6212-12-git-send-email-subhasish@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-04-2011 16:08, Subhasish Ghosh wrote:

> This patch adds the pruss CAN pinmux and registers the device
> with the pruss mfd driver.

> Signed-off-by: Subhasish Ghosh<subhasish@mistralsolutions.com>
> ---
>   arch/arm/mach-davinci/board-da850-evm.c |   46 +++++++++++++++++++++++++++++++
>   1 files changed, 46 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index e7fdf31..e1ff18c 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
[...]
> @@ -1117,6 +1118,43 @@ static __init int da850_evm_init_cpufreq(void)
>   static __init int da850_evm_init_cpufreq(void) { return 0; }
>   #endif
>
> +static const short da850_evm_pruss_can_pins[] = {
> +	DA850_PRUSS_PRU0_R31_0, DA850_PRUSS_PRU1_R30_15,
> +	DA850_PRUSS_PRU1_R31_18, DA850_GPIO2_0,
> +	-1
> +};
> +
> +static int __init da850_evm_pruss_can_setup(void)
> +{
> +	int ret, val = 0;
> +	void __iomem *cfg_chip3_reg;
> +
> +	ret = davinci_cfg_reg_list(da850_evm_pruss_can_pins);
> +	if (ret)
> +		pr_warning("%s: da850_evm_pruss_can_pins mux setup "
> +					"failed:%d\n", __func__, ret);

    Yet you continue to initialize... you should stop here I think.

> +	/* value = 0 to enable the CAN transceiver */
> +	ret = gpio_request_one(DA850_PRUSS_CAN_TRX_PIN,
> +			GPIOF_OUT_INIT_LOW, "pruss_can_en");
> +	if (ret) {
> +		pr_warning("Cannot setup GPIO %d\n", DA850_PRUSS_CAN_TRX_PIN);
> +		gpio_free(DA850_PRUSS_CAN_TRX_PIN);

    Doesn't gpio_request_one() handle freeing GPIO on error?

WBR, Sergei
