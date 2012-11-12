Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2KLVfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:35:20 -0500
Received: from smtp121.dfw.emailsrvr.com ([67.192.241.121]:46177 "EHLO
	smtp121.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2KLVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:35:16 -0500
Message-ID: <50A16BA2.2050304@calxeda.com>
Date: Mon, 12 Nov 2012 15:35:30 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/6 v4] clk, highbank: Prevent glitches in non-bypass
 reset mode
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com> <1352313166-28980-3-git-send-email-mark.langsdorf@calxeda.com> <20121112212412.20034.37835@nucleus>
In-Reply-To: <20121112212412.20034.37835@nucleus>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 03:24 PM, Mike Turquette wrote:
> Quoting Mark Langsdorf (2012-11-07 10:32:42)
>> The highbank clock will glitch with the current code if the
>> clock rate is reset without relocking the PLL. Program the PLL
>> correctly to preven glitches.
>>
>> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: mturquette@linaro.org
> 
> Hi Mark,
> 
> Looks fine to me.
> 
> I seem to be missing the rest of this series in my mail.  Did you want
> me to take only this patch (2/6) into clk-next or were you only looking
> for my ACK?

The entire series enables highbank cpufreq. Would you normally take this
patch through cpufreq-next with an ACK or directly through clk-next?

--Mark Langsdorf
Calxeda, Inc.

>> ---
>> Changes from v3
>>         Changelog text and patch name now correspond to the actual patch
>>         was clk, highbank: remove non-bypass reset mode
>> Changes from v2
>>         None
>> Changes from v1:
>>         Removed erroneous reformating.
>>
>>  drivers/clk/clk-highbank.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
>> index 52fecad..3a0b723 100644
>> --- a/drivers/clk/clk-highbank.c
>> +++ b/drivers/clk/clk-highbank.c
>> @@ -182,8 +182,10 @@ static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
>>                 reg |= HB_PLL_EXT_ENA;
>>                 reg &= ~HB_PLL_EXT_BYPASS;
>>         } else {
>> +               writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
>>                 reg &= ~HB_PLL_DIVQ_MASK;
>>                 reg |= divq << HB_PLL_DIVQ_SHIFT;
>> +               writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
>>         }
>>         writel(reg, hbclk->reg);
>>  
>> -- 
>> 1.7.11.7

