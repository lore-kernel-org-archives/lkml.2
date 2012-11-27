Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2K0DNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 22:13:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab2K0DNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 22:13:16 -0500
X-IronPort-AV: E=Sophos;i="4.83,325,1352044800"; 
   d="scan'208";a="6280538"
Message-ID: <50B43150.2000405@cn.fujitsu.com>
Date: Tue, 27 Nov 2012 11:19:44 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jianguo Wu <wujianguo@huawei.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        wujianguo <wujianguo106@gmail.com>, akpm@linux-foundation.org,
        rob@landley.net, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, jiang.liu@huawei.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, qiuxishi@huawei.com
Subject: Re: [PATCH v2 5/5] page_alloc: Bootmem limit with movablecore_map
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-6-git-send-email-tangchen@cn.fujitsu.com> <50B36354.7040501@gmail.com> <50B36B54.7050506@cn.fujitsu.com> <50B38F69.6020902@zytor.com> <50B41041.6030902@huawei.com>
In-Reply-To: <50B41041.6030902@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 11:12:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 11:12:50,
	Serialize complete at 2012/11/27 11:12:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/27/2012 08:58 AM, Jianguo Wu Wrote:
> On 2012/11/26 23:48, H. Peter Anvin wrote:
> 
>> On 11/26/2012 05:15 AM, Tang Chen wrote:
>>>
>>> Hi Wu,
>>>
>>> That is really a problem. And, before numa memory got initialized,
>>> memblock subsystem would be used to allocate memory. I didn't find any
>>> approach that could fully address it when I making the patches. There
>>> always be risk that memblock allocates memory on ZONE_MOVABLE. I think
>>> we can only do our best to prevent it from happening.
>>>
>>> Your patch is very helpful. And after a shot look at the code, it seems
>>> that acpi_numa_memory_affinity_init() is an architecture dependent
>>> function. Could we do this somewhere which is not depending on the
>>> architecture ?
>>>
>>
>> The movable memory should be classified as a non-RAM type in memblock,
>> that way we will not allocate from it early on.
>>
>> 	-hpa
> 
> 
> yep, we can put movable memory in reserved.regions in memblock.

Hmm, I don't think so. If so, memory in reserved.regions contain two type
memory: bootmem and movable memory. We will put all pages not in reserved.regions
into buddy system. If we put movable memory in reserved.regions, we have
no chance to put them to buddy system, and can't use them after system boots.

Thanks
Wen Congyang

> 
>>
>>
>> .
>>
> 
> 
> 
> 

