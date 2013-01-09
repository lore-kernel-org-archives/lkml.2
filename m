Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3AIQ0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:26:08 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63095 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab3AIQ0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:26:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130109085636.GB31678@gmail.com>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
	<1355937587-31730-3-git-send-email-lee.jones@linaro.org>
	<20130109085636.GB31678@gmail.com>
Date: Wed, 9 Jan 2013 17:26:04 +0100
Message-ID: <CAPDyKFpP6tWOGPka7VK+=1FOk-gUk3f2HrvwEXBVR0Hx8j_7Yg@mail.gmail.com>
Subject: Re: [PATCH 3/4] clk: ux500: Provide an alias for the SMSC911x
 Ethernet chip
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2013 09:56, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 19 Dec 2012, Lee Jones wrote:
>
>> In the case of some of the ux500 platforms, an Ethernet chip is
>> placed on an extended bus which is traditionally used as a NAND
>> flash chip placeholder. The p3_pclk0 clock is used to control it,
>> so we are required to provide and easy way to access it from the
>> SMSC911x driver. We do this using an alias provided by this patch.
>>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  drivers/clk/ux500/u8500_clk.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
>> index a601802..9d9add1 100644
>> --- a/drivers/clk/ux500/u8500_clk.c
>> +++ b/drivers/clk/ux500/u8500_clk.c
>> @@ -325,6 +325,7 @@ void u8500_clk_init(void)
>>       clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", U8500_CLKRST3_BASE,
>>                               BIT(0), 0);
>>       clk_register_clkdev(clk, "fsmc", NULL);
>> +     clk_register_clkdev(clk, NULL, "smsc911x");
>>
>>       clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", U8500_CLKRST3_BASE,
>>                               BIT(1), 0);
>> --
>> 1.7.9.5
>>
>
> I still need a maintiner Ack for this before I can push it.
>
> Mike?
>
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
