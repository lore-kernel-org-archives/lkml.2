Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab1BYTFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:05:32 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16690 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab1BYTFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:05:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6268"; a="76728161"
Message-ID: <4D67FD79.3070004@codeaurora.org>
Date: Fri, 25 Feb 2011 11:05:29 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] msm: scm: Mark inline asm as volatile
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>	 <1298573085-23217-2-git-send-email-sboyd@codeaurora.org> <1298635017.958.0.camel@e102144-lin.cambridge.arm.com>
In-Reply-To: <1298635017.958.0.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2011 03:56 AM, Will Deacon wrote:
> Hi Stephen,
>
> On Thu, 2011-02-24 at 18:44 +0000, Stephen Boyd wrote:
>> We don't want the compiler to remove these asm statements or
>> reorder them in any way. Mark them as volatile to be sure.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  arch/arm/mach-msm/scm.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
>> index f4b9bc9..ba57b5a 100644
>> --- a/arch/arm/mach-msm/scm.c
>> +++ b/arch/arm/mach-msm/scm.c
>> @@ -174,7 +174,7 @@ static u32 smc(u32 cmd_addr)
>>         register u32 r0 asm("r0") = 1;
>>         register u32 r1 asm("r1") = (u32)&context_id;
>>         register u32 r2 asm("r2") = cmd_addr;
>> -       asm(
>> +       asm volatile(
>>                 __asmeq("%0", "r0")
>>                 __asmeq("%1", "r0")
>>                 __asmeq("%2", "r1")
>> @@ -271,7 +271,7 @@ u32 scm_get_version(void)
>>                 return version;
>>
>>         mutex_lock(&scm_lock);
>> -       asm(
>> +       asm volatile(
>>                 __asmeq("%0", "r1")
>>                 __asmeq("%1", "r0")
>>                 __asmeq("%2", "r1")
>
>
> These asm blocks all have sensible looking output constraints. Why
> do they need to be marked volatile?

I'm not seeing any different code with or without this so I saw little
harm in marking them as volatile. I really don't want the compiler
moving them or deleting them so it seemed safer to just mark it volatile
to make sure nothing happens to the smc instructions.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

