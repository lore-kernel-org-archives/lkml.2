Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab0GTIz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 04:55:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50194 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758271Ab0GTIz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 04:55:56 -0400
Date: Tue, 20 Jul 2010 09:55:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@slimlogic.co.uk,
        akpm@linux-foundation.org, a.zummo@towertech.it, gortmaker@yahoo.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com
Subject: Re: [PATCH 2/3] mfd: MAX8998: Add interrupts support
Message-ID: <20100720085554.GH10222@rakim.wolfsonmicro.main>
References: <1279609058-32319-1-git-send-email-jy0922.shim@samsung.com>
 <1279609058-32319-2-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279609058-32319-2-git-send-email-jy0922.shim@samsung.com>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 03:57:37PM +0900, Joonyoung Shim wrote:
> Use genirq and provide seperated file for interrupts support.
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

...

> +
> +	for (i = 0; i < ARRAY_SIZE(max8998->irq_masks_cur); i++) {
> +		/*
> +		 * If there's been a change in the mask write it back
> +		 * to the hardware.
> +		 */
> +		if (max8998->irq_masks_cur[i] != max8998->irq_masks_cache[i]) {
> +			max8998->irq_masks_cache[i] = max8998->irq_masks_cur[i];
> +			max8998_write_reg(max8998->i2c, MAX8998_REG_IRQM1 + i,
> +					max8998->irq_masks_cur[i]);
> +		}

This code all looks oddly familiar :)

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
