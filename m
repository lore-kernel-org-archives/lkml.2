Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428Ab2KAMmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:42:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37178 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000Ab2KAMmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:42:21 -0400
Message-ID: <50926E03.8050102@ti.com>
Date: Thu, 1 Nov 2012 18:11:39 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 03/11] clk: davinci - common clk utilities to init
 clk driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1351181518-11882-4-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 9:41 PM, Murali Karicheri wrote:
> This is the common clk driver initialization functions for DaVinci
> SoCs and other SoCs that uses similar hardware architecture.
> clock.h also defines struct types for clock definitions in a SoC
> and clock data type for configuring clk-mux. The initialization
> functions are used by clock initialization code in a specific
> platform/SoC.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

> +struct clk *davinci_plldiv_clk(const char *name, const char *parent,
> +				struct clk_plldiv_data *data)
> +{
> +	/*
> +	 * This is a PLL divider clock with divider specified by
> +	 * div_reg in pll_div_data.
> +	 */
> +	data->reg = ioremap(data->phys_div_reg, 4);
> +	if (WARN_ON(!data->reg))
> +		return NULL;
> +
> +	return clk_register_davinci_plldiv(NULL, name, parent, data, &_lock);

This function does not exist at this point. Looks like you need to swap
3/11 with 4/11. Also, you should also add build infrastructure
(makefile, Kconfig) changes in the same patch that creates the file.
There is no point in adding those separately.

Thanks,
Sekhar
