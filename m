Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab2C1JDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:03:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:58188 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369Ab2C1JDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:03:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125997951"
Message-ID: <4F72D3B9.1070101@intel.com>
Date: Wed, 28 Mar 2012 17:02:49 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@kernel.org>, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [RFC PATCH 0/5] perf: Intel uncore pmu counting support
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>  <20120328064928.GA21725@gmail.com> <1332924580.2528.18.camel@twins>
In-Reply-To: <1332924580.2528.18.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 04:49 PM, Peter Zijlstra wrote:
> On Wed, 2012-03-28 at 08:49 +0200, Ingo Molnar wrote:
>> * Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>
>>> Hi, all
>>>
>>> Here is the RFC patches to add uncore counting support for Nehalem,
>>> Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
>>> The code is based on Lin Ming's old patches.
>>>
>>> You can use 'perf stat' to access to the uncore pmu. For example:
>>> perf stat -a -C 0 -e 'uncore_nhm/config=0xffff/' sleep 1
>>
>> My main complaint is that that's not user friendly *AT ALL*.
>>
>> You need to make this useful to mere mortals: go through the 
>> SDM, categorize interesting looking events, look at how it can 
>> be expressed via tooling, add a generic event where appropriate, 
>> provide examples, actually *USE* it to improve the kernel or an 
>> app and see the workflow as it happens and improve the tooling, 
>> etc.
> 
> Easiest way out here is add a /sys/bus/event_source/devices/*/events/
> directory which contains files who's name we can use as events and who's
> contents are of the form we would use given the format/ stuff.
> 
> Example, suppose a westmere,
> 
> $ cat /sys/bus/event_source/devices/cpu/events/frontend_stalled_cycles
> event=0x0e,umask=0x01,inv,cmask=1
> 
> I'll review the uncore patches later this week, but I suspect the whole
> cpu->node mapping stuff is still not done properly.
> 
> Also, quick question, did Intel fix the SNB uncore PMI?
No. furthermore there is completely no uncore PMI in Sandy Bridge-EP

Thanks.
