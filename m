Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab2EKByb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:54:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:23694 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab2EKBy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:54:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151653841"
Message-ID: <4FAC7153.80305@intel.com>
Date: Fri, 11 May 2012 09:54:27 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        hpa <hpa@zytor.com>
Subject: Re: [PATCH 4/9] perf: Generic intel uncore support
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>   <1335924440-11242-5-git-send-email-zheng.z.yan@intel.com>  <1336065156.22523.34.camel@twins> <4FAB6F99.6010408@intel.com> <1336644337.2527.95.camel@twins>
In-Reply-To: <1336644337.2527.95.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 06:05 PM, Peter Zijlstra wrote:
> On Thu, 2012-05-10 at 15:34 +0800, Yan, Zheng wrote:
>>
>> This code doesn't work for PCI uncore device if there are offline CPUs,
>> because topology_physical_package_id() always return 0 for offline CPUs.
> 
> Hmm, that sounds wrong.. one would expect something like BAD_APICID, -1
> or the correct number. hpa should we fix that?
> 
> Anyway,
> 
>> So besides the per CPU variable, we still need another data structure
>> to track the uncore boxes. Do you still want to use per CPU variable?
> 
> Well you don't really need the value for offline CPUs, until they're
> online right? 
Yes

> So all you need to do is iterate all the box muck in a
> hotplug handler and set the right pointer, no? (I suspect this would
> need to be done in CPU_STARTING).
The problem is that CPUs on a particular socket can all be offline. So
we need an extra data structure to track the uncore boxes. This means
that the memory addresses of uncore boxes are stored in two places.
It's a little tricky to keep the two places in sync. For example, In the
case of hot-plugging CPU, the per CPU pointers can only be set after the
PCI uncore devices are probed. How to handle the case that cpu hotplug
handler is executed before PCI uncore devices are probed? For the reason
listed above I still prefer not to use per CPU pointer.

Regards
Yan, Zheng
