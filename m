Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424666Ab2LFR2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:28:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50089 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424456Ab2LFR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:28:46 -0500
Message-ID: <50C0D5C6.1050305@gmail.com>
Date: Fri, 07 Dec 2012 01:28:38 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        wujianguo <wujianguo106@gmail.com>, akpm@linux-foundation.org,
        rob@landley.net, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, jiang.liu@huawei.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, wujianguo@huawei.com, qiuxishi@huawei.com
Subject: Re: [PATCH v2 5/5] page_alloc: Bootmem limit with movablecore_map
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-6-git-send-email-tangchen@cn.fujitsu.com> <50B36354.7040501@gmail.com> <50B36B54.7050506@cn.fujitsu.com> <50B38F69.6020902@zytor.com> <50B4304F.4070302@cn.fujitsu.com> <50B45021.2000009@zytor.com>
In-Reply-To: <50B45021.2000009@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa and Tang,
	How do you think about the attached patches, which reserves memory
for hotplug from memblock/bootmem allocator at early booting stages?
	Logically we split the task into three parts:
1) Provide a mechanism to specify zone_movable[] by kernel parameter.
   Patch 1-4 from Tang achieves this goal by adding "movablecore_map" kernel
   parameter.
2) Reserve memory for hotplug by reusing information provided by "movablecore_map".
   Patch 5 from Tang achieve this goal. And the attached patches provides
   another way to achieve the same goal by calling memblock_reserve() and newly
   introduced memblock interfaces.
3) Automatically reserve memory for hotplug according to firmware provided
   information based on the attached patches.

Regards!
Gerry

On 11/27/2012 01:31 PM, H. Peter Anvin wrote:
> On 11/26/2012 07:15 PM, Wen Congyang wrote:
>>
>> Hi, hpa
>>
>> The problem is that:
>> node1 address rang: [18G, 34G), and the user specifies movable map is [8G, 24G).
>> We don't know node1's address range before numa init. So we can't prevent
>> allocating boot memory in the range [24G, 34G).
>>
>> The movable memory should be classified as a non-RAM type in memblock. What
>> do you want to say? We don't save type in memblock because we only
>> add E820_RAM and E820_RESERVED_KERN to memblock.
>>
> 
> We either need to keep the type or not add it to the memblocks.
> 
>     -hpa
> 

