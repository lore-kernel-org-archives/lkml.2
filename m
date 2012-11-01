Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab2KALCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:02:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47720 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab2KALCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:02:21 -0400
Message-ID: <5092568C.5000805@ti.com>
Date: Thu, 1 Nov 2012 16:31:32 +0530
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
Subject: Re: [PATCH v3 01/11] clk: davinci - add main PLL clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-2-git-send-email-m-karicheri2@ti.com> <509119AE.6050505@ti.com> <50912BCE.5000401@ti.com>
In-Reply-To: <50912BCE.5000401@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 7:16 PM, Murali Karicheri wrote:
> On 10/31/2012 08:29 AM, Sekhar Nori wrote:

>>> +    /*
>>> +     * if fixed_multiplier is non zero, multiply pllm value by this
>>> +     * value.
>>> +     */
>>> +    if (pll_data->fixed_multiplier)
>>> +        mult =  pll_data->fixed_multiplier *
>>> +                (mult & pll_data->pllm_mask);
>>> +    else
>>> +        mult = (mult & pll_data->pllm_mask) + 1;
>> Hmm, this is interpreting the 'mult' register field differently in both
>> cases. In one case it is 'actual multiplier - 1' and in other case it is
>> the 'actual multiplier' itself. Can we be sure that the mult register
>> definition will change whenever there is a fixed multiplier in the PLL
>> block? I don't think any of the existing DaVinci devices have a fixed
>> multiplier. Is this on keystone?
> Read section 6.4.3 (PLL Mode) in DM365 documentation (SPRUFG5a.pdf) that
> states PLL multiplies the clock by 2x the value in the PLLM. In the old
> code this is handled by a if cpu_is_* macro that we can't use in the
> driver. So this is represented by a fixed_multiplier that can be set to
> 2 for DM365 and zero on other SoCs.

Thanks for the clarification.

Regards,
Sekhar
