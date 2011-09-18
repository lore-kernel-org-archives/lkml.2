Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1IRGc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 02:32:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49182 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1IRGbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 02:31:20 -0400
Date: Sun, 18 Sep 2011 00:24:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 4/5] ARM: gic: allow irq_start to be 0
Message-ID: <20110918062402.GG3523@ponder.secretlab.ca>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-5-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316017900-19918-5-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:31:39AM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> There's really no need to set irq_start per platform for the primary gic.
> The SGIs and PPIs are not handled as normal irqs, so how irqs 0-31 are
> setup doesn't really matter. So allow irq_start to be set to 0 to match
> the linux irq numbering.

Is this really what you want?  Linux irq 0 is not supposed to be used.
With the transition to dynamically allocated irq_descs, I want to make
sure 0 never gets assigned.

g.

> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  arch/arm/common/gic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
> index 666b278..d1ccc72 100644
> --- a/arch/arm/common/gic.c
> +++ b/arch/arm/common/gic.c
> @@ -359,7 +359,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
>  	gic = &gic_data[gic_nr];
>  	gic->dist_base = dist_base;
>  	gic->cpu_base = cpu_base;
> -	gic->irq_offset = (irq_start - 1) & ~31;
> +	gic->irq_offset = irq_start ? (irq_start - 1) & ~31 : 0;
>  
>  	if (gic_nr == 0)
>  		gic_cpu_base_addr = cpu_base;
> -- 
> 1.7.5.4
> 
