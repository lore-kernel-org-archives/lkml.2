Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2ANESh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 23:18:37 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1770 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2ANESg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 23:18:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6588"; a="154991170"
Message-ID: <4F11021A.8070407@codeaurora.org>
Date: Fri, 13 Jan 2012 20:18:34 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Turquette, Mike" <mturquette@ti.com>, andrew@lunn.ch,
        linaro-dev@lists.linaro.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, Colin Cross <ccross@google.com>,
        jeremy.kerr@canonical.com, sboyd@quicinc.com, magnus.damm@gmail.com,
        dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        arnd.bergmann@linaro.org, patches@linaro.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        richard.zhao@linaro.org, shawn.guo@freescale.com, paul@pwsan.com,
        linus.walleij@stericsson.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        skannan@quicinc.com
Subject: Re: [PATCH v4 3/6] clk: introduce the common clock framework
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org> <1323834838-2206-4-git-send-email-mturquette@linaro.org> <alpine.LFD.2.02.1112141007550.3020@ionos> <CAJOA=zO=gM2r4pCVo+orLqE9Q1SSw4h5nXsAHo-e_SHZAfvKDA@mail.gmail.com> <20111217110433.GC14547@n2100.arm.linux.org.uk>
In-Reply-To: <20111217110433.GC14547@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2011 03:04 AM, Russell King - ARM Linux wrote:
> On Fri, Dec 16, 2011 at 04:45:48PM -0800, Turquette, Mike wrote:
>> On Wed, Dec 14, 2011 at 5:18 AM, Thomas Gleixner<tglx@linutronix.de>  wrote:
>>> On Tue, 13 Dec 2011, Mike Turquette wrote:
>>>> +void __clk_unprepare(struct clk *clk)
>>>> +{
>>>> +     if (!clk)
>>>> +             return;
>>>> +
>>>> +     if (WARN_ON(clk->prepare_count == 0))
>>>> +             return;
>>>> +
>>>> +     if (--clk->prepare_count>  0)
>>>> +             return;
>>>> +
>>>> +     WARN_ON(clk->enable_count>  0);
>>>
>>> So this leaves the clock enable count set. I'm a bit wary about
>>> that. Shouldn't it either return (including bumping the prepare_count
>>> again) or call clk_disable() ?
>
> No it should not.
>
>> I've hit this in my port of OMAP.  It comes from this simple situation:
>>
>> driver 1 (adapted for clk_prepare/clk_unprepare):
>> clk_prepare(clk);
>> clk_enable(clk);
>>
>> ...
>>
>> driver2 (not adapted for clk_prepare/clk_unprepare):
>> clk_enable(clk);
>
> So this is basically buggy.  Look, it's quite simple.  Convert _all_
> your drivers to clk_prepare/clk_unprepare _before_ you start switching
> your platform to use these new functions.  You can do that _today_
> without exception.
>
> We must refuse to merge _any_ user which does this the old way - and
> we should have been doing this since my commit was merged into mainline
> to allow drivers to be converted.
>
> And stop trying to think of ways around this inside clk_prepare/
> clk_unprepare/clk_enable/clk_disable.  You can't do it.  Just fix _all_
> the drivers.  Now.  Before you start implementing clk_prepare/clk_unprepare.

I agree with Russell's suggestion. This is what I'm trying to do with 
the MSM platform. Not sure if I'm too optimistic, but as of today, I'm 
still optimistic I can push the MSM driver devs to get this done before 
we enable real prepare/unprepare support.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
