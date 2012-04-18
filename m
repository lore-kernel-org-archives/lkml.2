Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2DRJ4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:56:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54524 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2DRJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:56:08 -0400
Date: Wed, 18 Apr 2012 10:55:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clk: wm831x: Add initial WM831x clock driver
Message-ID: <20120418095556.GY24211@n2100.arm.linux.org.uk>
References: <1334736433-3402-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1334736433-3402-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334736433-3402-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 09:07:13AM +0100, Mark Brown wrote:
> +static __devexit int wm831x_clk_remove(struct platform_device *pdev)
> +{
> +	struct wm831x_clk *clkdata = dev_get_drvdata(&pdev->dev);
> +
> +	clk_unregister(clkdata->clkout_hw.clk);
> +	clk_unregister(clkdata->fll_hw.clk);
> +	clk_unregister(clkdata->xtal_hw.clk);

And another reason returning error codes from unregister functions is a
bad idea - you've just demonstrated above why that is.  You created this
function which returns an error code, but you're not checking it.
