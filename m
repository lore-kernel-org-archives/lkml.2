Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab2JKLEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:04:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44780 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab2JKLEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:04:34 -0400
Message-ID: <5076A79E.80502@ti.com>
Date: Thu, 11 Oct 2012 16:33:58 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>,
        <linux-c6x-dev@linux-c6x.org>, <cyril@ti.com>
Subject: Re: [PATCH v2 01/13] clk: davinci - add Main PLL clock driver
References: <1348683037-9705-1-git-send-email-m-karicheri2@ti.com> <1348683037-9705-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1348683037-9705-2-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/2012 11:40 PM, Murali Karicheri wrote:

> +struct clk_davinci_pll_data {
> +	/* physical addresses set by platform code */
> +	u32 phy_pllm;
> +	/* if PLL has a prediv register this should be non zero */
> +	u32 phy_prediv;
> +	/* if PLL has a postdiv register this should be non zero */
> +	u32 phy_postdiv;

"phys" is typically used for physical addresses. I couldn't immediately
related this to physical address when I looked at this variable outside
of this file.

Also, physical addresses should be of type phys_addr_t.

> +	/* mapped addresses. should be initialized by  */
> +	void __iomem *pllm;
> +	void __iomem *prediv;
> +	void __iomem *postdiv;
> +	u32 pllm_mask;
> +	u32 prediv_mask;
> +	u32 postdiv_mask;
> +	u32 num;

Wondering what num is for? May be it will be clear once you document the
complete structure as Linus suggested.

> +	/* framework flags */
> +	u32 flags;
> +	/* pll flags */
> +	u32 pll_flags;
> +       /* use this value for prediv */
> +	u32 fixed_prediv;

Why is this called "fixed". Isn't this the pre-divider value that user
can configure? Also, shouldn't there be a post-divider value that you
need as well.

> +	/* multiply PLLM by this factor. By default most SOC set this to zero
> +	 * that translates to a multiplier of 1 and incrementer of 1.
> +	 * To override default, set this factor
> +	 */
> +	u32 pllm_multiplier;

'm' in pllm stands for multiplier. So, instead of calling it
"pllm_multiplier", call it "pllm_val" instead?

Sorry about late comments on this, looks like I missed looking at this
structure altogether yesterday and had to go back to this only when I
tried understanding whats going on in 4/13

Thanks,
Sekhar
