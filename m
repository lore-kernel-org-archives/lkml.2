Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab2K0BPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:15:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:36192 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab2K0BPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:15:02 -0500
Message-ID: <50B41395.60808@huawei.com>
Date: Tue, 27 Nov 2012 09:12:53 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, wujianguo <wujianguo106@gmail.com>,
        <akpm@linux-foundation.org>, <rob@landley.net>,
        <isimatu.yasuaki@jp.fujitsu.com>, <laijs@cn.fujitsu.com>,
        <wency@cn.fujitsu.com>, <linfeng@cn.fujitsu.com>, <yinghai@kernel.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <minchan.kim@gmail.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>, <wujianguo@huawei.com>,
        <qiuxishi@huawei.com>
Subject: Re: [PATCH v2 5/5] page_alloc: Bootmem limit with movablecore_map
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-6-git-send-email-tangchen@cn.fujitsu.com> <50B36354.7040501@gmail.com> <50B36B54.7050506@cn.fujitsu.com> <50B38F69.6020902@zytor.com>
In-Reply-To: <50B38F69.6020902@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-26 23:48, H. Peter Anvin wrote:
> On 11/26/2012 05:15 AM, Tang Chen wrote:
>>
>> Hi Wu,
>>
>> That is really a problem. And, before numa memory got initialized,
>> memblock subsystem would be used to allocate memory. I didn't find any
>> approach that could fully address it when I making the patches. There
>> always be risk that memblock allocates memory on ZONE_MOVABLE. I think
>> we can only do our best to prevent it from happening.
>>
>> Your patch is very helpful. And after a shot look at the code, it seems
>> that acpi_numa_memory_affinity_init() is an architecture dependent
>> function. Could we do this somewhere which is not depending on the
>> architecture ?
>>
> 
> The movable memory should be classified as a non-RAM type in memblock,
> that way we will not allocate from it early on.
Hi Peter,

I have tried to reserved movable memory from bootmem allocator, but the
ACPICA subsystem is initialized later than setting up movable zone.
So still trying to figure out a way to setup/reserve movable zones
according to information from static ACPI tables such as SRAT/MPST etc.

Regards!
Gerry

> 
> 	-hpa
> 
> 
> .
> 


