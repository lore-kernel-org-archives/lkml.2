Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2HQMDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 08:03:33 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39023 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2HQMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 08:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <201208171134.32195.arnd@arndb.de>
References: <1345183330-20244-1-git-send-email-xiechao.mail@gmail.com>
	<1345183330-20244-3-git-send-email-xiechao.mail@gmail.com>
	<201208171134.32195.arnd@arndb.de>
Date: Fri, 17 Aug 2012 20:03:26 +0800
Message-ID: <CADApbejwG5F5pEicWSAb0308npupfHkE0fqTweec9ve2ZzkREw@mail.gmail.com>
Subject: Re: [PATCH V4 2/5] clk: mmp: add clock definition for pxa168
From: Chao Xie <xiechao.mail@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 7:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 17 August 2012, Chao Xie wrote:
>> +void __init pxa168_clk_init(void)
>> +{
>> +       struct clk *clk;
>> +       struct clk *uart_pll;
>> +       void __iomem *mpmu_base;
>> +       void __iomem *apmu_base;
>> +       void __iomem *apbc_base;
>> +
>> +       mpmu_base = ioremap(APB_PHYS_BASE + 0x50000, SZ_4K);
>> +       if (mpmu_base == NULL) {
>> +               pr_err("error to ioremap MPMU base\n");
>> +               return;
>> +       }
>> +
>> +       apmu_base = ioremap(AXI_PHYS_BASE + 0x82800, SZ_4K);
>> +       if (apmu_base == NULL) {
>> +               pr_err("error to ioremap APMU base\n");
>> +               return;
>> +       }
>> +
>> +       apbc_base = ioremap(APB_PHYS_BASE + 0x15000, SZ_4K);
>> +       if (apbc_base == NULL) {
>> +               pr_err("error to ioremap APBC base\n");
>> +               return;
>> +       }
>
> I hadn't noticed this before, but you are hardcoded physical address locations
> in the driver, which is not so good since we're trying to move all those
> locations to device tree. Maybe someone else has an idea to do this better.
>
>> +       clk = clk_register_fixed_rate(NULL, "clk32", NULL, CLK_IS_ROOT, 3200);
>> +       clk_register_clkdev(clk, "clk32", NULL);
>> +
>> +       clk =
>> +           clk_register_fixed_rate(NULL, "vctcxo", NULL, CLK_IS_ROOT,
>> +                                   26000000);
>> +       clk_register_clkdev(clk, "vctcxo", NULL);
>> +
>> +       clk =
>> +           clk_register_fixed_rate(NULL, "pll1", NULL, CLK_IS_ROOT, 624000000);
>> +       clk_register_clkdev(clk, "pll1", NULL);
>
> Ok, so you've managed to remove the array, good!
>
> I'm still not overly happy with the style of newline after "=", that is
> very unusual, and only saves you two characters per line. I'd say just move
> them each into one line as you did in the first one here. It's less important
> to align the arguments to the opening braces if you are trying to stay in the
> 80 character limit. Another option would be to rename the variable to just
> 'c' instead of 'clk' ;-)
>
>         Arnd
>
>
>         Arnd
hi
The clock tree is formatted into a table, and i used perl to generate
the code based on the table. In order to make the indent clearly, i
used the scripts/Lindent to automatically format the .c file.
I have tried to searched the parameter for indent, but i do not find
that anything can remove the the style of newline after "=", so in
order to not format the file line by line, i just accept the results
of indent.
Do you have any idea about it?
