Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab2JKKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:16:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60002 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393Ab2JKKQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:16:26 -0400
Message-ID: <50769C53.8030405@ti.com>
Date: Thu, 11 Oct 2012 15:45:47 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "Chemparathy, Cyril" <cyril@ti.com>
Subject: Re: [PATCH 01/13] calk: davinci - add Main PLL clock driver
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com> <1348682889-9509-2-git-send-email-m-karicheri2@ti.com> <507563C3.2000305@ti.com> <3E54258959B69E4282D79E01AB1F32B7041FB712@DFLE12.ent.ti.com>
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B7041FB712@DFLE12.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 8:04 PM, Karicheri, Muralidharan wrote:

>>>> +struct clk *clk_register_davinci_pll(struct device *dev, const char *name,
>>>> +			const char *parent_name,
>>>> +			struct clk_davinci_pll_data *pll_data) {
>>>> +	struct clk_init_data init;
>>>> +	struct clk_davinci_pll *pll;
>>>> +	struct clk *clk;
>>>> +
>>>> +	if (!pll_data)
>>>> +		return ERR_PTR(-ENODEV);
>>>> +
>>>> +	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
>>>> +	if (!pll)
>>>> +		return ERR_PTR(-ENOMEM);
>>>> +	init.name = name;
>>>> +	init.ops = &clk_pll_ops;
>>>> +	init.flags = pll_data->flags;
>>>> +	init.parent_names = (parent_name ? &parent_name : NULL);
>>>> +	init.num_parents = (parent_name ? 1 : 0);
>>>> +
>>>> +	pll->pll_data	= pll_data;
>>>> +	pll->hw.init = &init;
>>>> +
>>>> +	clk = clk_register(NULL, &pll->hw);
>>>> +	if (IS_ERR(clk))
>>>> +		kfree(pll);
>>>> +
>>>> +	return clk;
>>>> +}
>>>
>>> I guess there is an an "unregister" required as well which will free the pll memory
>>> allocated above and unregister the clock? Not sure if you would ever unregister a PLL,
>>> but providing this will probably help symmetry.
> Sekhar,
> 
> clk_unregister() itself is a null statement in clk.c. Besides none of the clk drivers presently have implemented the unregister(). So I believe this is unnecessary. 

I am ok with this.

> BTW, please review the v2 patch for the rest of the series. For the one you have already reviewed, it should be fine.

Okay. I see those now. BTW, this series also has a v2 in its 0/13. Are
there any differences between this and the other v2, or is that merely a
resend?

Thanks,
Sekhar
