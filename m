Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1LXSlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 13:41:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43386 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745Ab1LXSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 13:41:45 -0500
Date: Sat, 24 Dec 2011 18:41:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mfd: Add S5M core driver
Message-ID: <20111224184142.GA10515@opensource.wolfsonmicro.com>
References: <1324628892-12170-1-git-send-email-sbkim73@samsung.com> <1324628892-12170-2-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324628892-12170-2-git-send-email-sbkim73@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 05:28:08PM +0900, Sangbeom Kim wrote:
> S5M series are pmic including mutiple functional devices.
> It can support PMIC, RTC, Battery charger, codec.
> This patch implement core driver for s5m series.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looking good - a few nits that could be fixed incrementally unless
there's some reason to resend.

> +static struct regmap_config s5m_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +};

It would be worth considering turning on the register cache support - it
can provide a nice performance win for read/modify/write operations by
cutting out the read from hardware.  You don't need to provide any
defaults.

> +	s5m87xx = kzalloc(sizeof(struct s5m87xx_dev), GFP_KERNEL);
> +	if (s5m87xx == NULL)
> +		return -ENOMEM;

devm_kzalloc() saves error handling and cleanup code.
