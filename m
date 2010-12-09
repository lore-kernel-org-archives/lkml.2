Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0LIMQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:16:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:54420 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab0LIMQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:16:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,319,1288594800"; 
   d="scan'208";a="685459276"
Date: Thu, 9 Dec 2010 13:16:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500-core improved error handling in get_chip_id
Message-ID: <20101209121604.GF8884@sortiz-mobl>
References: <1291298912-3589-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291298912-3589-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Thu, Dec 02, 2010 at 03:08:32PM +0100, Mattias Wallin wrote:
> This patch improves the error handling in ab8500_get_chip_id.
Patch applied.
One general comment: Your title and changelog should be different. The former
should basically be a one liner explaining what you're doing, and the latter
should explain why and how you're doing so.

Cheers,
Samuel.


> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> ---
>  drivers/mfd/ab8500-core.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
> index d9640a6..e91b5b7 100644
> --- a/drivers/mfd/ab8500-core.c
> +++ b/drivers/mfd/ab8500-core.c
> @@ -103,8 +103,12 @@ static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
>  
>  static int ab8500_get_chip_id(struct device *dev)
>  {
> -	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
> -	return (int)ab8500->chip_id;
> +	struct ab8500 *ab8500;
> +
> +	if (!dev)
> +		return -EINVAL;
> +	ab8500 = dev_get_drvdata(dev->parent);
> +	return ab8500 ? (int)ab8500->chip_id : -EINVAL;
>  }
>  
>  static int set_register_interruptible(struct ab8500 *ab8500, u8 bank,
> -- 
> 1.7.2.2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
