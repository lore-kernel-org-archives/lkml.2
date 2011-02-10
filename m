Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1BJE0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:26:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39082 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1BJE0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:26:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6252"; a="73654480"
Message-ID: <4D536904.5080708@codeaurora.org>
Date: Wed, 09 Feb 2011 20:26:44 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>, Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC, PATCH 3/3] clk: add warnings for incorrect enable/prepare
 semantics
References: <201102011711.31258.jeremy.kerr@canonical.com>	<1297058877.800990.238556019385.3.gpush@pororo>	<20110207080555.GC27982@pengutronix.de>	<201102071608.42855.jeremy.kerr@canonical.com> <alpine.LFD.2.00.1102070908120.14920@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1102070908120.14920@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 06:24 AM, Nicolas Pitre wrote:
> On Mon, 7 Feb 2011, Jeremy Kerr wrote:
>
>> Hi Uwe,
>>
>>> This implies the warning is only issued on clocks that have a prepare
>>> callback.  If we want to enforce the new API the warning here shouldn't
>>> depend on clk->ops->prepare.  (clk_prepare and clk_unprepare need to
>>> be changed then to adapt the prepare_count even in the absence of
>>> clk->ops->prepare.)
>>
>> Yeah, it's a decision about either adding a small cost to all clk_prepare()s
>> (ie, adding cost when there is no prepare callback), or checking for the
>> correct prepare/enable semantics for all clocks (even when it doesn't matter
>> for that particular clock). I chose the first as more important, but happy to
>> go either way here.
>
> The prepare method being called from non-atomic context cannot be
> considered to be in a speed critical path.  Most of the time, this is
> going to be called on driver initialization or the like, and that's a
> relatively rare event. Therefore this really small cost to clk_prepare()
> is definitively worth it to help proper usage of the API.  If this ever
> becomes a problem then this could be confined to some CONFIG_CLK_DEBUG
> or the like.  But when introducing a new API it is best to be more
> strict to help people get its usage right (without going overboard with
> it of course).
>

Agree with Nicholas and Uwe. +1 for this request.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
