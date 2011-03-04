Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325Ab1CDXsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:48:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56084 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab1CDXsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:48:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6275"; a="77933930"
Message-ID: <4D717A5D.8010608@codeaurora.org>
Date: Fri, 04 Mar 2011 15:48:45 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5?= =?ISO-8859-1?Q?g?= 
	<arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mattias Wallin <Mattias.Wallin@stericsson.com>
Subject: Re: [PATCHv4 0/4] ARM: Fixing udelay() for SMP and non-SMP systems
References: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org> <AANLkTi=KU_zUrBsp0a9iJyj6RmTgYqZcffQynTV-2tKW@mail.gmail.com>
In-Reply-To: <AANLkTi=KU_zUrBsp0a9iJyj6RmTgYqZcffQynTV-2tKW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 02:10 AM, Linus Walleij wrote:
> 2010/12/20 Stephen Boyd<sboyd@codeaurora.org>:
>
>> These patches fix the udelay() issue pointed out on
>> arm-lkml[1][2]. A quick recap: some SMP machines can scale
>> their CPU frequencies independent of one another. loops_per_jiffy
>> is calibrated globally and used in __const_udelay(). If one CPU
>> is running faster than what the loops_per_jiffy is calculated
>> (or scaled) for, udelay() will be incorrect and not wait long
>> enough (or too long). A similar problem occurs if the cpu
>> frequency is scaled during a udelay() call.
>
> Hwt's happening to this patch set? We have applied it and
> implemented a timer for the U8500.
>
> Tested-by: Linus Walleij<linus.walleij@linaro.org>
>
> Mattias WALLIN can probably also provide a Tested-by:
> from ST-Ericsson if it helps.
>
> Generally I think this is good and important stuff that should
> be merged, will you be submitting it to Russells patch tracker
> or pull request for 2.6.39?
>

Thanks for testing and reporting it Linus. We are certainly interested 
in getting this in. If I'm not mistaken, the last time we sent it out, 
there was a C vs. assembly argument and got side tracked or no one acked 
or responded to it. Will try to send out the patches again within the 
next few weeks.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
