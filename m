Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1BXToJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:44:09 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56496 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1BXToG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:44:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76279744"
Message-ID: <4D66B505.6010702@codeaurora.org>
Date: Thu, 24 Feb 2011 11:44:05 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] msm: scm: Get cacheline size from CTR
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org> <1298573085-23217-5-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1102241959290.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102241959290.2701@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 11:01 AM, Thomas Gleixner wrote:
> On Thu, 24 Feb 2011, Stephen Boyd wrote:
>
>>
>>  /**
>>   * scm_call() - Send an SCM command
>>   * @svc_id: service identifier
>> @@ -243,11 +248,13 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
>>  	do {
>>  		u32 start = (u32)rsp;
>>  		u32 end = (u32)scm_get_response_buffer(rsp) + resp_len;
>> -		start &= ~(CACHELINESIZE - 1);
>> +		u32 cacheline_size = dcache_line_size();
>
> And why do you want to do that on every scm_call() invocation and on
> every loop of that code? If your dcache_line_size() changes at
> runtime, then you might have other problems.

I definitely don't want to do it for every loop. I'm fine with getting
it every scm_call() invocation though.

For now, I'll pull the end and cacheline_size variables out of the
do-while loop.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

