Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2CTRqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:46:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27418 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab2CTRqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:46:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6654"; a="174123420"
Message-ID: <efca11f1b68186dbf1771c09fe3a2f0a.squirrel@www.codeaurora.org>
In-Reply-To: <20120320140220.GE32469@S2101-09.ap.freescale.net>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
    <1331878280-2758-3-git-send-email-mturquette@linaro.org>
    <20120320140220.GE32469@S2101-09.ap.freescale.net>
Date: Tue, 20 Mar 2012 10:46:11 -0700 (PDT)
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Shawn Guo" <shawn.guo@linaro.org>
Cc: "Mike Turquette" <mturquette@linaro.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Paul Walmsley" <paul@pwsan.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>, patches@linaro.org,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Magnus Damm" <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        linaro-dev@lists.linaro.org, "Jeremy Kerr" <jeremy.kerr@canonical.com>,
        "Arnd Bergman" <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, March 20, 2012 7:02 am, Shawn Guo wrote:
> On Thu, Mar 15, 2012 at 11:11:19PM -0700, Mike Turquette wrote:
> ...
>> +struct clk_ops {
>> +	int		(*prepare)(struct clk_hw *hw);
>> +	void		(*unprepare)(struct clk_hw *hw);
>> +	int		(*enable)(struct clk_hw *hw);
>> +	void		(*disable)(struct clk_hw *hw);
>> +	int		(*is_enabled)(struct clk_hw *hw);
>> +	unsigned long	(*recalc_rate)(struct clk_hw *hw,
>> +					unsigned long parent_rate);
>
> I believe I have heard people love the interface with parent_rate
> passed in.  I love that too.  But I would like to ask the same thing
> on .round_rate and .set_rate as well for the same reason why we have
> it for .recalc_rate.

In my case, for most clocks, set rate involves reparenting. So, what does
passing parent_rate for these even mean? Passing parent_rate seems more
apt for recalc_rate since it's called when the parent rate changes -- so,
the actual parent itself is not expected to change.

I could ignore the parameter, but just wondering how many of the others
see value in this. And if we do add this parameter, it shouldn't be made
mandatory for the platform driver to use it (due to other assumptions the
clock framework might make).

-Saravana


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


