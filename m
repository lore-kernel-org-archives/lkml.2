Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159Ab2KASfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:35:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56018 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab2KASfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:35:05 -0400
Message-ID: <5092C0CB.5020504@ti.com>
Date: Thu, 1 Nov 2012 14:34:51 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 03/11] clk: davinci - common clk utilities to init
 clk driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-4-git-send-email-m-karicheri2@ti.com> <50926E03.8050102@ti.com>
In-Reply-To: <50926E03.8050102@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 08:41 AM, Sekhar Nori wrote:
> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>> This is the common clk driver initialization functions for DaVinci
>> SoCs and other SoCs that uses similar hardware architecture.
>> clock.h also defines struct types for clock definitions in a SoC
>> and clock data type for configuring clk-mux. The initialization
>> functions are used by clock initialization code in a specific
>> platform/SoC.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> +struct clk *davinci_plldiv_clk(const char *name, const char *parent,
>> +				struct clk_plldiv_data *data)
>> +{
>> +	/*
>> +	 * This is a PLL divider clock with divider specified by
>> +	 * div_reg in pll_div_data.
>> +	 */
>> +	data->reg = ioremap(data->phys_div_reg, 4);
>> +	if (WARN_ON(!data->reg))
>> +		return NULL;
>> +
>> +	return clk_register_davinci_plldiv(NULL, name, parent, data, &_lock);
> This function does not exist at this point. Looks like you need to swap
> 3/11 with 4/11. Also, you should also add build infrastructure
> (makefile, Kconfig) changes in the same patch that creates the file.
> There is no point in adding those separately.
>
> Thanks,
> Sekhar
>
Sekhar,

So the Makefile, Kconfig and new files should be in the same patch.
Also will re-order the 3/11 and 4/11 in the next revision.

Murali
