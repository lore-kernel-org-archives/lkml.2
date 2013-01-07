Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3AGUDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:03:44 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:33720 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560Ab3AGUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:03:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195abeA/15wQ6+4Txp52yt/
Date: Mon, 7 Jan 2013 12:03:38 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Afzal Mohammed <afzal@ti.com>
Subject: Re: [PATCH] omap: am33xx-hwmod: Fix wrongly terminated
 am33xx_usbss_mpu_irqs array
Message-ID: <20130107200338.GD14149@atomide.com>
References: <1357252342-6166-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357252342-6166-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [130103 14:35]:
> The IRQ array must be terminated by -1 and not by -1+OMAP_INTC_START
> This led to having a resource list of 100s of IRQs.

This is a bug for sure introduced with commit a2cfc509 (ARM: OMAP3+:
hwmod: Add AM33XX HWMOD data). Anybody care to ack this one?

Regards,

Tony
 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> index 081c71e..e402303 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> @@ -2070,7 +2070,7 @@ static struct omap_hwmod_irq_info am33xx_usbss_mpu_irqs[] = {
>  	{ .name = "usbss-irq", .irq = 17 + OMAP_INTC_START, },
>  	{ .name = "musb0-irq", .irq = 18 + OMAP_INTC_START, },
>  	{ .name = "musb1-irq", .irq = 19 + OMAP_INTC_START, },
> -	{ .irq = -1 + OMAP_INTC_START, },
> +	{ .irq = -1, },
>  };
>  
>  static struct omap_hwmod am33xx_usbss_hwmod = {
> -- 
> 1.7.12
> 
