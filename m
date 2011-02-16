Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab1BPExN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:53:13 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16111 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1BPExJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:53:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6258"; a="74663484"
Message-ID: <4D5B5835.4070407@codeaurora.org>
Date: Tue, 15 Feb 2011 20:53:09 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>, Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
References: <1297233693.242364.862698430999.1.gpush@pororo>	<4D53749B.6010102@codeaurora.org>	<201102151041.40655.jeremy.kerr@canonical.com> <4D5A100F.9000809@codeaurora.org>
In-Reply-To: <4D5A100F.9000809@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 09:33 PM, Saravana Kannan wrote:
> Russell, A question for you further down this email. Please take a look.

Russell, Ping... I will snip the rest of the discussion so that it's 
easy to spot the question.

>>>> +int clk_set_parent(struct clk *clk, struct clk *parent)
>>>> +{
>>>> + if (clk->ops->set_parent)
>>>> + return clk->ops->set_parent(clk, parent);
>>>
>>> I'm not sure on this one. If the prepare ops for a clock also calls the
>>> prepare ops on the parent, shouldn't we prevent changing the parent
>>> while the prepare/unprepare is going on?
>>
>> Again, this is related to set_rate during enable/disable or
>> prepare/unprepare;
>> we don't have defined semantics for this at present.
>
> After thinking about this the past couple of days, this looks like a
> location where the locking is more necessary than inside set rate. I
> always saw the parent clock as the clock that generates the clock signal
> from which this clock derives (divide, etc) it's clock signal from.
>
> Assuming Russell and/or the community agrees on the semantics of
> "parent", without the generic implementation grabbing the prepare_lock
> while setting the parent, there is no way for the specific clock driver
> implementations to cleanly ensure correctness. The only option for them
> would be to peek into the generic clock struct and grab the prepare lock
> -- to me that would be an ugly hack and/or layering violation that would
> cause problems later on.
>
> Russell/All,
>
> What's the meaning of a parent clock? Do you agree with my definition --
> "the parent clock is the clock that generates the clock signal from
> which the child clock derives (divide, etc) it's clock signal from."? Or
> is it open to interpretation by each implementation?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
