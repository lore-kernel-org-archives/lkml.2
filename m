Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab0KQHR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:17:29 -0500
Received: from [120.204.251.227] ([120.204.251.227]:58694 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751481Ab0KQHR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:17:28 -0500
Message-ID: <4CE3814B.5010008@leadcoretech.com>
Date: Wed, 17 Nov 2010 15:16:27 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101028 Lightning/1.0b2 Lanikai/3.1.6
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andrew Chew <AChew@nvidia.com>, "pawel@osciak.com" <pawel@osciak.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] videobuf: Initialize lists in videobuf_buffer.
References: <1289939083-27209-1-git-send-email-achew@nvidia.com> <4CE32B9D.1020705@leadcoretech.com> <643E69AA4436674C8F39DCC2C05F763816BB828A40@HQMAIL03.nvidia.com> <201011170811.06697.hverkuil@xs4all.nl>
In-Reply-To: <201011170811.06697.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 07:17:26.0599 (UTC) FILETIME=[7CCF2D70:01CB8627]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 03:11 PM, Hans Verkuil wrote:
> On Wednesday, November 17, 2010 02:38:09 Andrew Chew wrote:
>>>> diff --git a/drivers/media/video/videobuf-dma-contig.c
>>> b/drivers/media/video/videobuf-dma-contig.c
>>>> index c969111..f7e0f86 100644
>>>> --- a/drivers/media/video/videobuf-dma-contig.c
>>>> +++ b/drivers/media/video/videobuf-dma-contig.c
>>>> @@ -193,6 +193,8 @@ static struct videobuf_buffer
>>> *__videobuf_alloc_vb(size_t size)
>>>>    	if (vb) {
>>>>    		mem = vb->priv = ((char *)vb) + size;
>>>>    		mem->magic = MAGIC_DC_MEM;
>>>> +		INIT_LIST_HEAD(&vb->stream);
>>>> +		INIT_LIST_HEAD(&vb->queue);
>>>
>>> i think it no need to be init, it just a list-entry.
>>
>> Okay, if that's really the case, then sh_mobile_ceu_camera.c, pxa_camera.c, mx1_camera.c, mx2_camera.c, and omap1_camera.c needs to be fixed to remove that WARN_ON(!list_empty(&vb->queue)); in their videobuf_prepare() methods, because those WARN_ON's are assuming that vb->queue is properly initialized as a list head.
>>
>> Which will it be?
>>
>
> These list entries need to be inited. It is bad form to have uninitialized
> list entries. It is not as if this is a big deal to initialize them properly.

in kernel source code, list entry are not often to be inited.

for example, see mm/vmscan.c register_shrinker(), no one init the 
shrinker->list.

another example: see mm/swapfile.c  add_swap_extent(), no one init the
new_se->list.





