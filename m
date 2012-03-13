Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab2CMWlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:41:45 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:49635 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760074Ab2CMWln convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:41:43 -0400
MIME-Version: 1.0
In-Reply-To: <4F5FC090.90005@gmail.com>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-3-git-send-email-mturquette@linaro.org> <4F5FC090.90005@gmail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 13 Mar 2012 15:41:21 -0700
Message-ID: <CAJOA=zMtaiHWmUJJO7eWEmGQkNmkzHnr0B4zneDrEEirFn3hAw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
To: Rob Herring <robherring2@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Paul Walmsley <paul@pwsan.com>,
        linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 2:48 PM, Rob Herring <robherring2@gmail.com> wrote:
> Mike,
>
> On 03/10/2012 01:54 AM, Mike Turquette wrote:
>> The common clock framework defines a common struct clk useful across
>> most platforms as well as an implementation of the clk api that drivers
>> can use safely for managing clocks.
>>
>> The net result is consolidation of many different struct clk definitions
>> and platform-specific clock framework implementations.
>>
>> This patch introduces the common struct clk, struct clk_ops and an
>> implementation of the well-known clock api in include/clk/clk.h.
>> Platforms may define their own hardware-specific clock structure and
>> their own clock operation callbacks, so long as it wraps an instance of
>> struct clk_hw.
>>
>> See Documentation/clk.txt for more details.
>>
>> This patch is based on the work of Jeremy Kerr, which in turn was based
>> on the work of Ben Herrenschmidt.
>>
>> Signed-off-by: Mike Turquette <mturquette@linaro.org>
>> Signed-off-by: Mike Turquette <mturquette@ti.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
>> Cc: Paul Walmsley <paul@pwsan.com>
>> Cc: Shawn Guo <shawn.guo@freescale.com>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> Cc: Richard Zhao <richard.zhao@linaro.org>
>> Cc: Saravana Kannan <skannan@codeaurora.org>
>> Cc: Magnus Damm <magnus.damm@gmail.com>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Cc: Linus Walleij <linus.walleij@stericsson.com>
>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: Amit Kucheria <amit.kucheria@linaro.org>
>> Cc: Deepak Saxena <dsaxena@linaro.org>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>
> snip
>
>> +
>> +     /*
>> +      * walk the list of orphan clocks and reparent any that are children of
>> +      * this clock
>> +      */
>> +     hlist_for_each_entry(orphan, tmp, &clk_orphan_list, child_node)
>
> In __clk_init, this needs to be hlist_for_each_entry_safe as entries can
> be removed.

Thanks for the catch Rob.  I'll take this in.

Regards,
Mike

>
> Rob
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
