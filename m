Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2DZJgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:36:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47102 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2DZJgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:36:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6692"; a="185084335"
Message-ID: <4d67387a86d99cbb4e2acf68d3588b1c.squirrel@www.codeaurora.org>
In-Reply-To: <20120426084201.GF17184@pengutronix.de>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
    <4F98EB10.2000505@codeaurora.org>
    <20120426084201.GF17184@pengutronix.de>
Date: Thu, 26 Apr 2012 02:36:37 -0700 (PDT)
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Sascha Hauer" <s.hauer@pengutronix.de>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Mike Turquette" <mturquette@linaro.org>,
        "Arnd Bergman" <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, "Andrew Lunn" <andrew@lunn.ch>,
        "Paul Walmsley" <paul@pwsan.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Magnus Damm" <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Richard Zhao" <richard.zhao@linaro.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Deepak Saxena" <dsaxena@linaro.org>,
        "Amit Kucheria" <amit.kucheria@linaro.org>,
        "Jamie Iles" <jamie@jamieiles.com>,
        "Jeremy Kerr" <jeremy.kerr@canonical.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Shawn Guo" <shawn.guo@freescale.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, April 26, 2012 1:42 am, Sascha Hauer wrote:
> On Wed, Apr 25, 2012 at 11:28:32PM -0700, Saravana Kannan wrote:
>>
>> >diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
>> >index 6e58f11..8e97491 100644
>> >--- a/drivers/clk/clk-mux.c
>> >+++ b/drivers/clk/clk-mux.c
>> >@@ -95,6 +95,7 @@ struct clk *clk_register_mux(struct device *dev,
>> const char *name,
>> >  {
>>
>> I would really like to remove these functions. At least until we add
>> device tree support where each clock is listed in device tree.
>>
>> At present, these functions seem to be abused more than actually
>> being used appropriately.
>
> I think this goes in my direction. Still exactly this abuse how you call
> it makes me relatively independent of for example the changes you
> introduce with your patch. Had I static initializers I would now have
> to start a rebase orgy.

In the other email you say you have to change. Here you say, you don't
have to change. Hopefully, you didn't have to change much -- I was aiming
for that. If there was agreement about removing these functions, I was
planning on helping move the current users after this patch merged.

I think in the long run this will result in less changes for you and more
readable code. If clk_register() adds another optional param, you can't
get around that without having to write more wrapper functions or changing
any existing ones you might have. But with this struct, the common clock
code can be written in a way so that the a value of 0 for the new param
defaults to the behavior that was there before the param was added.

Something to think about: With these wrapper calls, one would do a lot of
kalloc and copying of small items when one knows at compile time what the
clocks are going to be.

Anyway, I understand that some people see value in this. That's why I'm
bringing it up for discussion instead of just doing it in my patch.

-Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

