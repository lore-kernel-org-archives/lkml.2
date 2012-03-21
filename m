Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2CUDKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 23:10:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63404 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2CUDKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 23:10:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6655"; a="171996452"
Message-ID: <4F6946AA.4070201@codeaurora.org>
Date: Tue, 20 Mar 2012 20:10:34 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <1331878280-2758-3-git-send-email-mturquette@linaro.org> <20120320140220.GE32469@S2101-09.ap.freescale.net> <efca11f1b68186dbf1771c09fe3a2f0a.squirrel@www.codeaurora.org> <CAJOA=zNmgSQfYAUZ-vqqTk0w3s3eKz3tjVOpyDgO35Q_Ogkz0g@mail.gmail.com>
In-Reply-To: <CAJOA=zNmgSQfYAUZ-vqqTk0w3s3eKz3tjVOpyDgO35Q_Ogkz0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 04:53 PM, Turquette, Mike wrote:
> On Tue, Mar 20, 2012 at 10:46 AM, Saravana Kannan
> <skannan@codeaurora.org>  wrote:
>> On Tue, March 20, 2012 7:02 am, Shawn Guo wrote:
>>> On Thu, Mar 15, 2012 at 11:11:19PM -0700, Mike Turquette wrote:
>>> ...
>>>> +struct clk_ops {
>>>> +    int             (*prepare)(struct clk_hw *hw);
>>>> +    void            (*unprepare)(struct clk_hw *hw);
>>>> +    int             (*enable)(struct clk_hw *hw);
>>>> +    void            (*disable)(struct clk_hw *hw);
>>>> +    int             (*is_enabled)(struct clk_hw *hw);
>>>> +    unsigned long   (*recalc_rate)(struct clk_hw *hw,
>>>> +                                    unsigned long parent_rate);
>>>
>>> I believe I have heard people love the interface with parent_rate
>>> passed in.  I love that too.  But I would like to ask the same thing
>>> on .round_rate and .set_rate as well for the same reason why we have
>>> it for .recalc_rate.
>>
>> In my case, for most clocks, set rate involves reparenting. So, what does
>> passing parent_rate for these even mean? Passing parent_rate seems more
>> apt for recalc_rate since it's called when the parent rate changes -- so,
>> the actual parent itself is not expected to change.
>
>  From my conversations with folks across many platforms, I think that
> the way your clock tree expects to change rates is the exception, not
> the rule.  As such you should just ignore the parent_rate parameter as
> it useless to you.
>
>> I could ignore the parameter, but just wondering how many of the others
>> see value in this. And if we do add this parameter, it shouldn't be made
>> mandatory for the platform driver to use it (due to other assumptions the
>> clock framework might make).
>
>  From my rough census of folks that actually need .set_rate support, I
> think that everyone except MSM could benefit from this.  Your concept
> of clk_set_rate is everyone else's clk_set_parent.

To clarify, MSM's set parent is a subset of steps needed to be done to 
finish set parent. So, it's not that we just randomly decided to swap 
the meanings of these two functions.

Also, I think don't think the difference in view of set_rate is due to 
the difference in the clock trees between platforms with complicated 
trees. I think it's more because of who actually decides the rates for 
the clock tree. It looks like some platforms pick a top-down approach to 
deciding the rates of the clock tre while others pick a bottom-up approach.

> Ignoring the new parameter should cause you no harm.

As long as this is guaranteed, I have no problems with Shawn's suggestion.

> It does make me
> wonder if it would be a good idea to pass in the parent rate for
> .set_parent, which is analogous to .set_rate in many ways.

I need to think a bit more about this.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
