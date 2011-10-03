Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab1JCWQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:16:00 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:45926 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab1JCWPy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:15:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E8A30F2.7010502@gmail.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com> <4E8A30F2.7010502@gmail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 3 Oct 2011 15:15:33 -0700
Message-ID: <CAJOA=zPZYE7R3y_Ybrq=PMAouL4cnOHkjsg+pR2R8yLzZ9YMaQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        amit.kucheria@linaro.org, richard.zhao@linaro.org,
        grant.likely@secretlab.ca, dsaxena@linaro.org,
        arnd.bergmann@linaro.org, shawn.guo@freescale.com, skannan@quicinc.com,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 3:02 PM, Rob Herring <robherring2@gmail.com> wrote:
> Mike,
>
> On 09/22/2011 05:26 PM, Mike Turquette wrote:
>
>> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
>> index 6db161f..e2a9719 100644
>> --- a/drivers/clk/clkdev.c
>> +++ b/drivers/clk/clkdev.c
>> @@ -23,6 +23,13 @@
>>  static LIST_HEAD(clocks);
>>  static DEFINE_MUTEX(clocks_mutex);
>>
>> +/* For USE_COMMON_STRUCT_CLK, these are provided in clk.c, but not exported
>> + * through other headers; we don't want them used anywhere but here. */
>> +#ifdef CONFIG_USE_COMMON_STRUCT_CLK
>> +extern int __clk_get(struct clk *clk);
>> +extern void __clk_put(struct clk *clk);
>> +#endif
>> +
>
> This is dead code left from prior versions.

Indeed it is.  Will pull it out for V3.

Thanks,
Mike

> Rob
>
