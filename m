Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab0KOC4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:56:13 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46011 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab0KOC4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:56:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6167"; a="62855353"
Message-ID: <8bd62d321211c93af883cd2ad404e802.squirrel@www.codeaurora.org>
In-Reply-To: <1289765858.24270.240.camel@m0nster>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
    <1289619000-13167-10-git-send-email-stepanm@codeaurora.org>
    <1289765858.24270.240.camel@m0nster>
Date: Sun, 14 Nov 2010 18:56:01 -0800 (PST)
Subject: Re: [PATCH 09/14] msm: iommu: Kconfig option for cacheable page 
     tables
From: "Stepan Moskovchenko" <stepanm@codeaurora.org>
To: "Daniel Walker" <dwalker@codeaurora.org>
Cc: "Stepan Moskovchenko" <stepanm@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, 2010-11-12 at 19:29 -0800, Stepan Moskovchenko wrote:
>>
>> +config IOMMU_PGTABLES_L2
>> +	depends on ARCH_MSM8X60
>> +	depends on MMU
>> +	depends on CPU_DCACHE_DISABLE=n
>> +	depends on SMP
>> +	bool "Cacheable IOMMU page tables"
>> +	default y
>> +	help
>> +	  Allows the IOMMU page tables to be brought into the L2 cache. This
>> +	  improves the TLB miss latency at the expense of potential pollution
>> +	  of the L2 cache. This option has been shown to improve multimedia
>> +	  performance in some cases.
>> +
>> +	  If unsure, say Y here.
>
> Why would someone want this off?
>
> The other thing is that you usually want this included with the code
> that uses the option.

The code that uses it had gone in during a previous patch series, but I
didn't want to meddle in the Kconfig just yet, especially since the option
only improves performance and does not add new functionality at a high
level. This patch should be the last of what is needed for this feature.

You would want to turn this off if you wanted more deterministic behavior
from the multimedia subsystem, such as when trying to run benchmarks for
the worst-case behavior in terms of memory latency and TLB misses. You
might also want to turn it off if you are debugging memory problems that
you suspect might be related to the cache maintenance code, in which case
turning this off would give an idea as to whether that is the problem.
Similarly, this needs to be off (and will be, due to the dependencies) if
certain required things (like the Dcache, MMU, etc) have been disabled.
Finally, if you are doing things with the MMSS that you know will not
result in many TLB misses, (or if you know that you can tolerate high miss
latency) you may as well turn this off to avoid the (small) bit of cache
pollution.

Steve

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


