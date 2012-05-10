Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2EJPt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:49:29 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35118 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599Ab2EJPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:49:28 -0400
Date: Thu, 10 May 2012 17:49:25 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: lm3533-core: Fix calling regmap_update_bits() with
 mask and val arguments swapped
Message-ID: <20120510154925.GB29437@localhost>
References: <1336664102.15392.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336664102.15392.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:35:02PM +0800, Axel Lin wrote:
> Current code calls regmap_update_bits() with mask and val arguments swapped.
> Fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Signed-off-by: Johan Hovold <jhovold@gmail.com>

> ---

Ouch, I was sure I'd fixed that in the submitted v2.

/Johan


>  drivers/mfd/lm3533-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
> index 75f4b7f..4a006c2 100644
> --- a/drivers/mfd/lm3533-core.c
> +++ b/drivers/mfd/lm3533-core.c
> @@ -128,7 +128,7 @@ int lm3533_update(struct lm3533 *lm3533, u8 reg, u8 val, u8 mask)
>  
>  	dev_dbg(lm3533->dev, "update [%02x]: %02x/%02x\n", reg, val, mask);
>  
> -	ret = regmap_update_bits(lm3533->regmap, reg, val, mask);
> +	ret = regmap_update_bits(lm3533->regmap, reg, mask, val);
>  	if (ret < 0) {
>  		dev_err(lm3533->dev, "failed to update register %02x: %d\n",
>  								reg, ret);
