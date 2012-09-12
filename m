Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2ILVwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:52:37 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:36525 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751194Ab2ILVwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:52:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ttga9puTPhBO3iAmAjBEo
Date: Wed, 12 Sep 2012 14:52:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul@pwsan.com
Subject: Re: [PATCH 2/2] ARM: AM33XX: hwmod: Add OMAP_INTC_START offset to
 all module int nos
Message-ID: <20120912215232.GE5997@atomide.com>
References: <1347484551-11775-1-git-send-email-hvaibhav@ti.com>
 <1347484551-11775-3-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347484551-11775-3-git-send-email-hvaibhav@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaibhav Hiremath <hvaibhav@ti.com> [120912 14:17]:
> With recent migration of omap architectures to SPARSE_IRQ framework,
> it is important to add OMAP_INTC_START to all interrupt numbers
> which will be eventually requested by drivers.
> 
> This is required in order to get AM33XX boot functionality.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c |  168 ++++++++++++++--------------
>  1 files changed, 84 insertions(+), 84 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> index 7b7ed08..3c320f4 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c

You should just have on top of this file:

#define OMAP_INTC_START		0

Then Paul can apply this, and while merging with the sparseirq
changes, the above can be removed.

> @@ -72,7 +72,7 @@ static struct omap_hwmod_class am33xx_emif_hwmod_class = {
>  };
>  
>  static struct omap_hwmod_irq_info am33xx_emif_irqs[] = {
> -	{ .name = "ddrerr0", .irq = 101 },
> +	{ .name = "ddrerr0", .irq = 101 + OMAP_INTC_START },
>  	{ .irq = -1 }
>  };
>  

Then these should be fixed up to have trailing commas
as requested by Russell earlier on several occasions.

Regards,

Tony

