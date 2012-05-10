Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2EJBJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:09:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:64320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2EJBJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151208724"
Message-ID: <4FAB1548.6050806@intel.com>
Date: Thu, 10 May 2012 09:09:28 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] perf: Allow pmu to choose cpu on which to install
 event
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com> <1335924440-11242-3-git-send-email-zheng.z.yan@intel.com> <4FAA10FB.1030008@linux.vnet.ibm.com>
In-Reply-To: <4FAA10FB.1030008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 02:38 PM, Anshuman Khandual wrote:
> On Wednesday 02 May 2012 07:37 AM, Yan, Zheng wrote:
> 
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Allow the pmu->event_init callback to change event->cpu, so pmu can
>> choose cpu on which to install event.
>>
>> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
>> ---
>>  kernel/events/core.c |   13 +++++++++----
>>  1 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 32cfc76..84911de 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -6250,6 +6250,8 @@ SYSCALL_DEFINE5(perf_event_open,
>>  		}
>>  	}
>>
>> +	get_online_cpus();
> 
> Why this protection against cpu hotplug operation ? Is this because PMU now can change event->cpu
> during event initialization (specific to uncore PMU events) or this protection has always been required
> for normal on-cpu HW PMU events also and we added it right now ?
> 
I think it's always required. Because when creating a perf event, 'cpu online' is checked by
find_get_context, the cpu can go offline after find_get_context return.

Regards
Yan, Zheng
