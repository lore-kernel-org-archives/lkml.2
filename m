Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2E3U24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:28:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52160 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab2E3U2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:28:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6727"; a="196112322"
Message-ID: <4FC68304.9050208@codeaurora.org>
Date: Wed, 30 May 2012 13:28:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] clk: add extension API
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com> <4FC5DFCF.1020606@codeaurora.org> <20120530194059.GA13243@gmail.com>
In-Reply-To: <20120530194059.GA13243@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/12 12:40, Mike Turquette wrote:
> I also wonder if exposing some of these knobs should be done in the
> basic clock types.  Meaning that instead of having additional calls in
> the clk.h API those calls could be exposed by the basic clock types that
> map to the actions.

What do you mean by basic clock types that map to actions? Perhaps an
example?

>
> The question that needs to be answered is this: do generic drivers need
> access to these additional functions (clk.h) or just the platform code
> which implements some of the clock logic (basic clock types &
> platform-speciic clock types).

At least for tegra it looks like they need reset assertion and
deassertion in generic drivers.

$ git grep tegra_periph_reset_assert
arch/arm/mach-tegra/clock.c:void tegra_periph_reset_assert(struct clk *c)
arch/arm/mach-tegra/clock.c:EXPORT_SYMBOL(tegra_periph_reset_assert);
arch/arm/mach-tegra/include/mach/clk.h:void tegra_periph_reset_assert(struct clk *c);
arch/arm/mach-tegra/pcie.c:     tegra_periph_reset_assert(tegra_pcie.pcie_xclk);
arch/arm/mach-tegra/pcie.c:     tegra_periph_reset_assert(tegra_pcie.afi_clk);
arch/arm/mach-tegra/pcie.c:     tegra_periph_reset_assert(tegra_pcie.pex_clk);
arch/arm/mach-tegra/pcie.c:     tegra_periph_reset_assert(tegra_pcie.pcie_xclk);
arch/arm/mach-tegra/pcie.c:     tegra_periph_reset_assert(tegra_pcie.afi_clk);
arch/arm/mach-tegra/powergate.c:        tegra_periph_reset_assert(clk);
drivers/i2c/busses/i2c-tegra.c: tegra_periph_reset_assert(i2c_dev->clk);
drivers/input/keyboard/tegra-kbc.c:     tegra_periph_reset_assert(kbc->clk);
drivers/staging/nvec/nvec.c:    tegra_periph_reset_assert(nvec->i2c_clk);

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

