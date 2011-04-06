Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1DFJPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:15:09 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:42354 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab1DFJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:15:08 -0400
Message-ID: <4D9C2ED7.9010906@shipmail.org>
Date: Wed, 06 Apr 2011 11:13:59 +0200
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Airlie <airlied@redhat.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758
References: <20110329145651.GA1641@gentoo.trippels.de> <20110405163141.GA1651@x4.trippels.de> <20110406085407.GA1634@x4.trippels.de>
In-Reply-To: <20110406085407.GA1634@x4.trippels.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, Konrad

I think we need to back out this change as soon as possible. I will 
follow up the discussion with Konrad on how we should attempt to handle 
vm passthrough as soon as things settle down a bit over here. Hopefully 
this week.

Thomas



On 04/06/2011 10:54 AM, Markus Trippelsdorf wrote:
> On 2011.04.05 at 18:31 +0200, Markus Trippelsdorf wrote:
>    
>> On 2011.03.29 at 16:56 +0200, Markus Trippelsdorf wrote:
>>      
>>> Just came across this WARNING (running latest git kernel):
>>>
>>> Mar 29 09:14:39 gentoo kernel: udev[888]: starting version 164
>>> Mar 29 15:45:45 gentoo kernel: ------------[ cut here ]------------
>>> Mar 29 15:45:45 gentoo kernel: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 ttm_put_pages+0x1c6/0x2b0()
>>> Mar 29 15:45:45 gentoo kernel: Hardware name: System Product Name
>>>        
>> It happened again today.
>>
>>   ------------[ cut here ]------------
>>   WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 ttm_put_pages+0x1c6/0x2c0()
>>   Hardware name: System Product Name
>>   Pid: 680, comm: kworker/u:6 Not tainted 2.6.39-rc1-00254-gd297f96 #5
>>   Call Trace:
>>   [<ffffffff810736af>] warn_slowpath_common+0x6f/0xa0
>>   [<ffffffff810737fa>] warn_slowpath_null+0x1a/0x20
>>   [<ffffffff812c7726>] ttm_put_pages+0x1c6/0x2c0
>>   [<ffffffff812bff7d>] ttm_tt_free_alloced_pages+0xbd/0x100
>>   [<ffffffff812c0a5c>] ttm_tt_swapout+0x1bc/0x2c0
>>   [<ffffffff812c2365>] ttm_bo_swapout+0x1a5/0x240
>>   [<ffffffff812b5637>] ? drm_mm_kmalloc+0x37/0xe0
>>   [<ffffffff812bf3b8>] ttm_shrink+0xd8/0x140
>>   [<ffffffff8108eb01>] ? queue_work+0x21/0x60
>>   [<ffffffff812bf420>] ? ttm_shrink+0x140/0x140
>>   [<ffffffff812bf439>] ttm_shrink_work+0x19/0x20
>>   [<ffffffff8108dade>] process_one_work+0x11e/0x4e0
>>   [<ffffffff8108e4ce>] worker_thread+0x16e/0x360
>>   [<ffffffff8108e360>] ? manage_workers.isra.28+0x260/0x260
>>   [<ffffffff810932ac>] kthread+0x8c/0xa0
>>   [<ffffffff8152a394>] kernel_thread_helper+0x4/0x10
>>   [<ffffffff81093220>] ? kthread_flush_work_fn+0x20/0x20
>>   [<ffffffff8152a390>] ? gs_change+0xb/0xb
>>   ---[ end trace cb7fc1aad109a0a7 ]---
>>   ------------[ cut here ]------------
>>      
> Looks like this is caused by f9820a46dd7888b05a36e81166fb1abcc47dcc3f :
>
>   ttm: Utilize the DMA API for pages that have TTM_PAGE_FLAG_DMA32 set.
>
> CCing the relevant people.
>
>    

