Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab2FAGBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 02:01:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52075 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab2FAGBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 02:01:52 -0400
Message-ID: <4FC85AC9.8010707@kernel.dk>
Date: Fri, 01 Jun 2012 08:01:45 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Asai Thambi S P <asamymuthupa@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 05/11] mtip32xx: Set block queue boundary variables
References: <4FC57B1B.5010901@micron.com> <4FC7130B.6040506@kernel.dk> <4FC794BD.1000309@micron.com> <x49sjegb7h4.fsf@segfault.boston.devel.redhat.com> <4FC7B491.9030105@micron.com> <x49hauwb3e1.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49hauwb3e1.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 08:40 PM, Jeff Moyer wrote:
>>>>>> @@ -3631,7 +3631,11 @@ skip_create_disk:
>>>>>>  	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
>>>>>>  	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
>>>>>>  	blk_queue_physical_block_size(dd->queue, 4096);
>>>>>> +	blk_queue_max_hw_sectors(dd->queue, 0xffff);
>>>>>> +	blk_queue_max_segment_size(dd->queue, 0x400000);
>>>>>>  	blk_queue_io_min(dd->queue, 4096);
>>>>>> +	dd->queue->nr_requests = 255;
>>>>>
>>>>> ->nr_requests isn't a boundary variable you set for the queue. It's set
>>>>> by the core bits, or by the user via the sysfs interface.
>>>>>
>>>>> So you should not touch that from the driver.
>>>>>
>>>>
>>>> Ok.
>>>>
>>>> I saw scsi lib module changing it, so thought of changing the value close to
>>>> device queue depth.
>>>
>>> That's actually a fair point.  What is the device queue depth for this
>>> card?
>>>
>> 256
> 
> Jens, I actually think changing nr_requests makes sense;  the only
> question in my mind is where to do it.  (There's no point in artificially
> limiting the device by default.)  IIRC, your general rule was to set this
> value to 2x the device's queue depth.  So, given that this driver
> doesn't use the blk-tag interfaces, what do you think would be the
> cleanest way to bump nr_requests in this (and the more general) case?

But it doesn't matter for this case, the driver isn't consuming request
structures, hence the value set doesn't make any difference. So the only
limiter of queue depth is the driver itself.

-- 
Jens Axboe

