Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2FUInM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:43:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:57783 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab2FUInJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:43:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183117772"
Message-ID: <4FE2DE9A.70202@intel.com>
Date: Thu, 21 Jun 2012 16:43:06 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V6 0/13] perf: Intel uncore pmu counting support
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com> <1340208092.21745.114.camel@twins> <4FE28823.80704@intel.com> <CABPqkBTi8-yKg_kzFTwLe1_m2Zprt5vGk9WPQW14yHQpy=PiWw@mail.gmail.com>
In-Reply-To: <CABPqkBTi8-yKg_kzFTwLe1_m2Zprt5vGk9WPQW14yHQpy=PiWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 04:10 PM, Stephane Eranian wrote:
> On Thu, Jun 21, 2012 at 4:34 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> On 06/21/2012 12:01 AM, Peter Zijlstra wrote:
>>>
>>> ok, so with this stuff something like:
>>>
>>>   perf stat -ae uncore/event=clockticks/ foo
>>>
>>> will register a counter per cpu, which is somewhat silly since we only
>>> need one per node. What would be the best way to 'fix' this?
>>>
>>> We could of course create another variant of -a which iterates nodes
>>> instead of cpus, -N or so.
>>>
>>> Alternatively we could try and describe this in sysfs in some way, one
>>> possibility would be to include a link to /sys/devices/system/{cpu,node}
>>> or somesuch and use that link to iterate the correct space.
>>>
>>> Any other suggestions?
>>>
>> How about treat the 'cpu' parameter for uncore event as socket id instead
>> of cpu id?
>>
> But that does not address the use case of Peter, i.e., no cpu parameter passed.
> Looks like sysfs might be the only way to do this in a portable manner.
> 
It does. For example, on a dual socket system, perf can only register uncore
counter with 'cpu' parameter is equal to 0 or 1. This method is hacky, but it
requires minimal change for the kernel and perf tool.

Regards
Yan, Zheng

