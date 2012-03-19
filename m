Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032738Ab2CSTyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:54:23 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:44543 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030416Ab2CSTyW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <4F6716DD.5090900@ti.com>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <4F6716DD.5090900@ti.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 19 Mar 2012 12:53:50 -0700
Message-ID: <CAJOA=zMPrf-JH_Pmzvkb==1Ew0g4oVS2L=ecJE3WxXsJ4GWkgg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
To: Rajendra Nayak <rnayak@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@freescale.com>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 4:22 AM, Rajendra Nayak <rnayak@ti.com> wrote:
> On Friday 16 March 2012 11:41 AM, Mike Turquette wrote:
>> +/*
>> + * calculate the new rates returning the topmost clock that has to be
>> + * changed.
>> + */
>> +static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long
>> rate)
>> +{
>> +       struct clk *top = clk;
>> +       unsigned long best_parent_rate = clk->parent->rate;
>
>
> Shouldn't you check for a valid parent before dereferencing it? A
> clk_set_rate() on a root clock might throw up some issues otherwise.

Yes, the clk_calc_new_rates code assumes a valid parent pointer in
several locations.  Thanks for the catch.  Will roll into my fixes
series.

Regards,
Mike
