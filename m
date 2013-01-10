Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab3AJCAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:00:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6780 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3AJCAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:00:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,441,1355068800"; 
   d="scan'208";a="6554366"
Message-ID: <50EE1B82.4090601@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 09:38:10 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, akpm@linux-foundation.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, sparclinux@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v5 01/14] memory-hotplug: try to offline the memory twice
 to avoid dependence
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-2-git-send-email-tangchen@cn.fujitsu.com> <50D96543.6010903@parallels.com> <50DFD7F7.5090408@cn.fujitsu.com> <50ED8834.1090804@parallels.com>
In-Reply-To: <50ED8834.1090804@parallels.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 09:38:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 09:38:32,
	Serialize complete at 2013/01/10 09:38:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Glauber,

On 01/09/2013 11:09 PM, Glauber Costa wrote:
>>
>> We try to make all page_cgroup allocations local to the node they are describing
>> now. If the memory is the first memory onlined in this node, we will allocate
>> it from the other node.
>>
>> For example, node1 has 4 memory blocks: 8-11, and we online it from 8 to 11
>> 1. memory block 8, page_cgroup allocations are in the other nodes
>> 2. memory block 9, page_cgroup allocations are in memory block 8
>>
>> So we should offline memory block 9 first. But we don't know in which order
>> the user online the memory block.
>>
>> I think we can modify memcg like this:
>> allocate the memory from the memory block they are describing
>>
>> I am not sure it is OK to do so.
>
> I don't see a reason why not.

I'm not sure, but if we do this, we could bring in a fragment for each
memory block (a memory section, 128MB, right?). Is this a problem when
we use large page (such as 1GB page) ?

Even if not, will these fragments make any bad effects ?

Thank. :)

>
> You would have to tweak a bit the lookup function for page_cgroup, but
> assuming you will always have the pfns and limits, it should be easy to do.
>
> I think the only tricky part is that today we have a single
> node_page_cgroup, and we would of course have to have one per memory
> block. My assumption is that the number of memory blocks is limited and
> likely not very big. So even a static array would do.
>
> Kamezawa, do you have any input in here?
>

