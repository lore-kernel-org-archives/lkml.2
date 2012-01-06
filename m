Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2AFQ7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:59:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42990 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845Ab2AFQ7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:59:45 -0500
Message-ID: <4F072843.6050306@ti.com>
Date: Fri, 6 Jan 2012 17:58:43 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <devicetree-discuss@lists.ozlabs.org>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Russell King <linux@arm.linux.org.uk>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        "open list:ARM/QUALCOMM MSM..." <linux-arm-msm@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Barry Song <baohua.song@csr.com>, Thomas Gleixner <tglx@linutronix.de>,
        open list:
	OMAP SUPPORT <linux-omap@vger.kernel.org>,
        Andrew Victor <linux@maxim.org.za>,
        "open list:ARM/ATMEL AT91RM9..." 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        David Woodhouse <dwmw2@infradead.org>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH] irqdomain: Initialize number of IRQs for simple domains
References: <1325860112-22051-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1325860112-22051-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 1/6/2012 3:28 PM, Thierry Reding wrote:
> The irq_domain_add() function needs the number of interrupts in the
> domain to properly initialize them. In addition the allocated domain
> is now returned by the irq_domain_{add,generate}_simple() helpers.

[...]

> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index d587560..bf67781 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -66,8 +66,11 @@ static struct of_device_id intc_match[] __initdata = {
>   static void __init omap_generic_init(void)
>   {
>   	struct device_node *node = of_find_matching_node(NULL, intc_match);
> -	if (node)
> -		irq_domain_add_simple(node, 0);
> +	if (node) {
> +		struct irq_domain *domain;
> +		domain = irq_domain_add_simple(node, 0, INTCPS_NR_IRQS);

The number of interrupts will depend on the OMAP generation. That one is 
just valid for the 3430 INTC controller.
Since the previous code was using zero, I guess that using 0 there 
should be fine.

Moreover, that piece of code should not exist anymore on 3.3 if the 
series I sent last month to leverage Rob's DT interrupt init is merged [1].

I've just ping Rob and Grant on that series to get a status.

Regards,
Benoit


[1] http://www.spinics.net/lists/linux-omap/msg62124.html
