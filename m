Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2K0NFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:05:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40326 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab2K0NE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:04:59 -0500
X-IronPort-AV: E=Sophos;i="4.83,328,1352044800"; 
   d="scan'208";a="6285999"
Message-ID: <50B4B6BE.3000902@cn.fujitsu.com>
Date: Tue, 27 Nov 2012 20:49:02 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bob Liu <lliubbo@gmail.com>
CC: hpa@zytor.com, akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, jiang.liu@huawei.com,
        yinghai@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        m.szyprowski@samsung.com
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <CAA_GA1d7CxHvmZELvD_DO6u5tu1WBqfmLiuEzeFo=xMzuW50Tg@mail.gmail.com> <50B479FA.6010307@cn.fujitsu.com> <CAA_GA1ezZJyqVL=Dp5U2zzNw6bkfMKJY_STkt3E7TXkUYcv+jQ@mail.gmail.com>
In-Reply-To: <CAA_GA1ezZJyqVL=Dp5U2zzNw6bkfMKJY_STkt3E7TXkUYcv+jQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 20:49:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 20:49:47,
	Serialize complete at 2012/11/27 20:49:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 08:09 PM, Bob Liu wrote:
> On Tue, Nov 27, 2012 at 4:29 PM, Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>> Hi Liu,
>>
>> This feature is used in memory hotplug.
>>
>> In order to implement a whole node hotplug, we need to make sure the
>> node contains no kernel memory, because memory used by kernel could
>> not be migrated. (Since the kernel memory is directly mapped,
>> VA = PA + __PAGE_OFFSET. So the physical address could not be changed.)
>>
>> User could specify all the memory on a node to be movable, so that the
>> node could be hot-removed.
>>
>
> Thank you for your explanation. It's reasonable.
>
> But i think it's a bit duplicated with CMA, i'm not sure but maybe we
> can combine it with CMA which already in mainline?
>
Hi Liu,

Thanks for your advice. :)

CMA is Contiguous Memory Allocator, right?  What I'm trying to do is
controlling where is the start of ZONE_MOVABLE of each node. Could
CMA do this job ?

And also, after a short investigation, CMA seems need to base on
memblock. But we need to limit memblock not to allocate memory on
ZONE_MOVABLE. As a result, we need to know the ranges before memblock
could be used. I'm afraid we still need an approach to get the ranges,
such as a boot option, or from static ACPI tables such as SRAT/MPST.

I'm don't know much about CMA for now. So if you have any better idea,
please share with us, thanks. :)


