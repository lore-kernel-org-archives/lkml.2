Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1BXTuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:50:51 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19150 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1BXTus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:50:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76281103"
Message-ID: <4D66B68F.6010706@codeaurora.org>
Date: Thu, 24 Feb 2011 11:50:39 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] msm: scm: Get cacheline size from CTR
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org> <1298573085-23217-5-git-send-email-sboyd@codeaurora.org> <4D66B236.4030003@ru.mvista.com>
In-Reply-To: <4D66B236.4030003@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 11:32 AM, Sergei Shtylyov wrote:
> Stephen Boyd wrote:
>
>> @@ -207,6 +204,14 @@ static int __scm_call(const struct scm_command
>> *cmd)
>>      return ret;
>>  }
>>  
>> +static inline u32 dcache_line_size(void)
>> +{
>> +    u32 ctr;
>> +
>> +    asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
>> +    return 4 << ((ctr >> 16) & 0xf);
>> +}
>
>    Won't generic cache_line_size() macro do instead? It's defined as
> L1_CACHE_BYTES.
>

Interesting. It would be the same value (32) but I'm not sure how
multi-platform friendly that will be since L1_CACHE_BYTES is (1 <<
CONFIG_ARM_L1_CACHE_SHIFT). I suppose we can punt supporting platforms
with different cache line sizes in one kernel for another day.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

