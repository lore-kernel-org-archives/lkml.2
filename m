Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab2K1FPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 00:15:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab2K1FPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 00:15:03 -0500
X-IronPort-AV: E=Sophos;i="4.83,332,1352044800"; 
   d="scan'208";a="6289929"
Message-ID: <50B59F5B.5030400@cn.fujitsu.com>
Date: Wed, 28 Nov 2012 13:21:31 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, wujianguo <wujianguo106@gmail.com>,
        hpa@zytor.com, akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <50B42F32.4050107@gmail.com> <50B58965.7040703@cn.fujitsu.com> <50B58CA9.9010606@huawei.com>
In-Reply-To: <50B58CA9.9010606@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/28 13:14:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/28 13:14:34,
	Serialize complete at 2012/11/28 13:14:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/28/2012 12:01 PM, Jiang Liu Wrote:
> On 2012-11-28 11:47, Tang Chen wrote:
>> On 11/27/2012 11:10 AM, wujianguo wrote:
>>>
>>> Hi Tang,
>>>     DMA address can't be set as movable, if some one boot kernel with
>>> movablecore_map=4G@0xa00000 or other memory region that contains DMA address,
>>> system maybe boot failed. Should this case be handled or mentioned
>>> in the change log and kernel-parameters.txt?
>>
>> Hi Wu,
>>
>> I think we can use MAX_DMA_PFN and MAX_DMA32_PFN to prevent setting DMA
>> address as movable. Just ignore the address lower than them, and set
>> the rest as movable. How do you think ?
>>
>> And, since we cannot figure out the minimum of memory kernel needs, I
>> think for now, we can just add some warning into kernel-parameters.txt.
>>
>> Thanks. :)
> On one other OS, there is a mechanism to dynamically convert pages from
> movable zones into normal zones.

The OS auto does it? Or the user coverts it?

We can convert pages from movable zones into normal zones by the following
interface:
echo online_kernel >/sys/devices/system/memory/memoryX/state

We have posted a patchset to implement it, and it is in mm tree now.

Thanks
Wen Congyang

> 
> Regards!
> Gerry
> 
>>
>>>
>>> Thanks,
>>> Jianguo Wu
>>>
>>
>> .
>>
> 
> 
> 

