Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab2K1FRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 00:17:35 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:45734 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab2K1FRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 00:17:33 -0500
Message-ID: <50B59E54.9090107@huawei.com>
Date: Wed, 28 Nov 2012 13:17:08 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, wujianguo <wujianguo106@gmail.com>,
        <hpa@zytor.com>, <akpm@linux-foundation.org>, <rob@landley.net>,
        <isimatu.yasuaki@jp.fujitsu.com>, <laijs@cn.fujitsu.com>,
        <linfeng@cn.fujitsu.com>, <yinghai@kernel.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <minchan.kim@gmail.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <50B42F32.4050107@gmail.com> <50B58965.7040703@cn.fujitsu.com> <50B58CA9.9010606@huawei.com> <50B59F5B.5030400@cn.fujitsu.com>
In-Reply-To: <50B59F5B.5030400@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-28 13:21, Wen Congyang wrote:
> At 11/28/2012 12:01 PM, Jiang Liu Wrote:
>> On 2012-11-28 11:47, Tang Chen wrote:
>>> On 11/27/2012 11:10 AM, wujianguo wrote:
>>>>
>>>> Hi Tang,
>>>>     DMA address can't be set as movable, if some one boot kernel with
>>>> movablecore_map=4G@0xa00000 or other memory region that contains DMA address,
>>>> system maybe boot failed. Should this case be handled or mentioned
>>>> in the change log and kernel-parameters.txt?
>>>
>>> Hi Wu,
>>>
>>> I think we can use MAX_DMA_PFN and MAX_DMA32_PFN to prevent setting DMA
>>> address as movable. Just ignore the address lower than them, and set
>>> the rest as movable. How do you think ?
>>>
>>> And, since we cannot figure out the minimum of memory kernel needs, I
>>> think for now, we can just add some warning into kernel-parameters.txt.
>>>
>>> Thanks. :)
>> On one other OS, there is a mechanism to dynamically convert pages from
>> movable zones into normal zones.
> 
> The OS auto does it? Or the user coverts it?
> 
> We can convert pages from movable zones into normal zones by the following
> interface:
> echo online_kernel >/sys/devices/system/memory/memoryX/state
> 
> We have posted a patchset to implement it, and it is in mm tree now.
OS automatically converts it, no manual operations needed.


