Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2K0Gru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:47:50 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:25264 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab2K0Grs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:47:48 -0500
Message-ID: <50B461EA.4090506@huawei.com>
Date: Tue, 27 Nov 2012 14:47:06 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: wujianguo <wujianguo106@gmail.com>, <hpa@zytor.com>,
        <akpm@linux-foundation.org>, <rob@landley.net>,
        <isimatu.yasuaki@jp.fujitsu.com>, <laijs@cn.fujitsu.com>,
        <wency@cn.fujitsu.com>, <linfeng@cn.fujitsu.com>,
        <jiang.liu@huawei.com>, <yinghai@kernel.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <minchan.kim@gmail.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <50B42F32.4050107@gmail.com> <50B45318.3020605@cn.fujitsu.com>
In-Reply-To: <50B45318.3020605@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/11/27 13:43, Tang Chen wrote:

> On 11/27/2012 11:10 AM, wujianguo wrote:
>> On 2012-11-23 18:44, Tang Chen wrote:
>>> [What we are doing]
>>> This patchset provide a boot option for user to specify ZONE_MOVABLE memory
>>> map for each node in the system.
>>>
>>> movablecore_map=nn[KMG]@ss[KMG]
>>>
>>
>> Hi Tang,
>>     DMA address can't be set as movable, if some one boot kernel with
>> movablecore_map=4G@0xa00000 or other memory region that contains DMA address,
>> system maybe boot failed. Should this case be handled or mentioned
>> in the change log and kernel-parameters.txt?
> 
> Hi Wu,
> 
> Right, DMA address can't be set as movable. And I should have mentioned
> it in the doc more clear. :)
> 
> Actually, the situation is not only for DMA address. Because we limited
> the memblock allocation, even if users did not specified the DMA
> address, but set too much memory as movable, which means there was too
> little memory for kernel to use, kernel will also fail to boot.
> 
> I added the following info into doc, but obviously it was not clear
> enough. :)
> +        If kernelcore or movablecore is also specified,
> +        movablecore_map will have higher priority to be
> +        satisfied. So the administrator should be careful that
> +        the amount of movablecore_map areas are not too large.
> +        Otherwise kernel won't have enough memory to start.
> 
> 
> And about how to fix it, as you said, we can handle the situation if
> user specified DMA address as movable. But how to handle "too little
> memory for kernel to start" case ?  Is there any info about how much
> at least memory kernel needs ?
> 

As I know, bootmem is mostly used by page structs when CONFIG_SPARSEMEM=y.
But it is hard to calculate how much bootmem is needed exactly.

> 
> Thanks for the comments. :)
> 
>>
>> Thanks,
>> Jianguo Wu
>>
> 
> 
> 
> .
> 



