Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2KAGHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:07:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31354 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab2KAGH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:07:29 -0400
X-IronPort-AV: E=Sophos;i="4.80,692,1344182400"; 
   d="scan'208";a="6114314"
Message-ID: <509212FC.8070802@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 14:13:16 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PART3 Patch 00/14] introduce N_MEMORY
References: <1351670652-9932-1-git-send-email-wency@cn.fujitsu.com> <alpine.DEB.2.00.1210311112010.8809@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210311112010.8809@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 14:06:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/01 14:06:43,
	Serialize complete at 2012/11/01 14:06:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/01/2012 02:16 AM, David Rientjes Wrote:
> On Wed, 31 Oct 2012, Wen Congyang wrote:
> 
>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> This patch is part3 of the following patchset:
>>     https://lkml.org/lkml/2012/10/29/319
>>
>> Part1 is here:
>>     https://lkml.org/lkml/2012/10/31/30
>>
>> Part2 is here:
>>     http://marc.info/?l=linux-kernel&m=135166705909544&w=2
>>
>> You can apply this patchset without the other parts.
>>
>> we need a node which only contains movable memory. This feature is very
>> important for node hotplug. So we will add a new nodemask
>> for all memory. N_MEMORY contains movable memory but N_HIGH_MEMORY
>> doesn't contain it.
>>
>> We don't remove N_HIGH_MEMORY because it can be used to search which
>> nodes contains memory that the kernel can use.
>>
> 
> This doesn't describe why we need the new node state, unfortunately.  It 

1. Somethimes, we use the node which contains the memory that can be used by
   kernel.
2. Sometimes, we use the node which contains the memory.

In case1, we use N_HIGH_MEMORY, and we use N_MEMORY in case2.

> makes sense to boot with node(s) containing only ZONE_MOVABLE, but it 
> doesn't show why we need a nodemask to specify such nodes and such 

Sorry for confusing you.
We don't add a nodemask to specify nodes which contain only ZONE_MOVABLE.
We want to add a nodemask(N_MEMORY) to specify nodes which contain memory.
In part3, we don't implement the node which only contain ZONE_MOVABLE, so
N_MEMORY is N_HIGH_MEMORY. We will add this nodemask when we implement
the node which contain only ZONE_MOVABLE.

In this patchset, we try to change N_HIGH_MEMORY to N_MEMORY for case2.

Thanks
Wen Congyang

> information should be available from the kernel log or /proc/zoneinfo.
> 
> Node hotplug should fail if all memory cannot be offlined, so why do we 
> need another nodemask?  Only offline the node if all memory is offlined.
> 

