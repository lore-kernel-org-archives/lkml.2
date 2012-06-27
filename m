Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2F0LLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:11:07 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:53323 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab2F0LLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:11:05 -0400
Message-ID: <4FEAEA41.7070502@ti.com>
Date: Wed, 27 Jun 2012 16:40:57 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: Re: [PATCH v2] clk: Add support for rate table based dividers
References: <1340794893-20869-1-git-send-email-rnayak@ti.com> <4FEAE89D.3090702@pengutronix.de>
In-Reply-To: <4FEAE89D.3090702@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2012 04:33 PM, Marc Kleine-Budde wrote:
> On 06/27/2012 01:01 PM, Rajendra Nayak wrote:
>> Some divider clks do not have any obvious relationship
>> between the divider and the value programmed in the
>> register. For instance, say a value of 1 could signify divide
>> by 6 and a value of 2 could signify divide by 4 etc.
>> Also there are dividers where not all values possible
>> based on the bitfield width are valid. For instance
>> a 3 bit wide bitfield can be used to program a value
>> from 0 to 7. However its possible that only 0 to 4
>> are valid values.
>>
>> All these cases need the platform code to pass a simple
>> table of divider/value tuple, so the framework knows
>> the exact value to be written based on the divider
>> calculation and can also do better error checking.
>>
>> This patch adds support for such rate table based
>> dividers.
>>
>> Also since this means adding a new parameter to the
>> clk_register_divider(), update all existing users of
>> it.
>>
>> Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>> Cc: Sascha Hauer<kernel@pengutronix.de>
>> Cc: Viresh Kumar<viresh.linux@gmail.com>
>> ---
>>   arch/arm/mach-imx/clk.h            |    2 +-
>>   drivers/clk/clk-divider.c          |   67 ++++++++++++++++++++++++++++++++++--
>>   drivers/clk/spear/spear3xx_clock.c |    4 +-
>>   drivers/clk/spear/spear6xx_clock.c |    4 +-
>>   include/linux/clk-private.h        |    3 +-
>>   include/linux/clk-provider.h       |   10 +++++-
>>   6 files changed, 80 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
>> index 1bf64fe..8cb6f97 100644
>> --- a/arch/arm/mach-imx/clk.h
>> +++ b/arch/arm/mach-imx/clk.h
>> @@ -56,7 +56,7 @@ static inline struct clk *imx_clk_divider(const char *name, const char *parent,
>>   		void __iomem *reg, u8 shift, u8 width)
>>   {
>>   	return clk_register_divider(NULL, name, parent, CLK_SET_RATE_PARENT,
>> -			reg, shift, width, 0,&imx_ccm_lock);
>> +			reg, shift, width, 0, , NULL,&imx_ccm_lock);
>                                             ^^^^^
>
> Is this valid C-Syntax?

Nope, its not. Thanks for catching. Will built test with imx and spear
configs before the next spin.

>
> Marc
>

