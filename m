Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1FIXbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:31:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31197 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1FIXbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:31:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6372"; a="96773526"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, stable@kernel.org
Subject: Re: [PATCH] msm: timer: compensate for timer shift in msm_read_timer_count
References: <1307591042-2369-1-git-send-email-johlstei@codeaurora.org>
	<1307626910.16418.1.camel@m0nster>
Date: Thu, 09 Jun 2011 16:31:06 -0700
In-Reply-To: <1307626910.16418.1.camel@m0nster> (Daniel Walker's message of
	"Thu, 09 Jun 2011 06:41:50 -0700")
Message-ID: <8ya1uz2inut.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09 2011, Daniel Walker wrote:

>> diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
>> index 38b95e9..b3579fe 100644
>> --- a/arch/arm/mach-msm/timer.c
>> +++ b/arch/arm/mach-msm/timer.c
>> @@ -100,7 +100,7 @@ static cycle_t msm_read_timer_count(struct clocksource *cs)
>>  {
>>  	struct msm_clock *clk = container_of(cs, struct msm_clock, clocksource);
>>  
>> -	return readl(clk->global_counter);
>> +	return readl(clk->global_counter) >> clk->shift;
>>  }
>
> Could you comment in the code with something explaining what the shift
> is doing.

Probably best to describe this near msm_clock's definition (or
MSM_DGT_SHIFT), since it is a bit unclear what these values are.
A good (but short) description of how the shifts and even why.

The comment shouldn't be in the function body (CodingStyle, chapter 8).

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
