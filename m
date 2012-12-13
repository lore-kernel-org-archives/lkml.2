Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2LMCqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:46:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:33859 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab2LMCqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:46:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,270,1355126400"; 
   d="scan'208";a="180227392"
Message-ID: <50C940E8.2020001@intel.com>
Date: Thu, 13 Dec 2012 10:43:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, preeti@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org,
        viresh.kumar@linaro.org
Subject: Re: [RFC PATCH v2 3/6] sched: pack small tasks
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org> <1355319092-30980-4-git-send-email-vincent.guittot@linaro.org> <50C93AC1.1060202@intel.com>
In-Reply-To: <50C93AC1.1060202@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 10:17 AM, Alex Shi wrote:
> On 12/12/2012 09:31 PM, Vincent Guittot wrote:
>> During the creation of sched_domain, we define a pack buddy CPU for each CPU
>> when one is available. We want to pack at all levels where a group of CPU can
>> be power gated independently from others.
>> On a system that can't power gate a group of CPUs independently, the flag is
>> set at all sched_domain level and the buddy is set to -1. This is the default
>> behavior.
>> On a dual clusters / dual cores system which can power gate each core and
>> cluster independently, the buddy configuration will be :
>>
>>       | Cluster 0   | Cluster 1   |
>>       | CPU0 | CPU1 | CPU2 | CPU3 |
>> -----------------------------------
>> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
>>
>> Small tasks tend to slip out of the periodic load balance so the best place
>> to choose to migrate them is during their wake up. The decision is in O(1) as
>> we only check again one buddy CPU
> 
> Just have a little worry about the scalability on a big machine, like on
> a 4 sockets NUMA machine * 8 cores * HT machine, the buddy cpu in whole
> system need care 64 LCPUs. and in your case cpu0 just care 4 LCPU. That
> is different on task distribution decision.

In above big machine example, only one buddy cpu is not sufficient on
each of level, like for 4 sockets level, maybe tasks can just full fill
2 sockets, then we just use 2 sockets, that is more performance/power
efficient. But one buddy cpu here need to spread tasks to 4 sockets all.


