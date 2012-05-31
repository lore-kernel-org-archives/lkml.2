Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab2EaSkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:40:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab2EaSkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:40:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Asai Thambi S P <asamymuthupa@micron.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 05/11] mtip32xx: Set block queue boundary variables
References: <4FC57B1B.5010901@micron.com> <4FC7130B.6040506@kernel.dk>
	<4FC794BD.1000309@micron.com>
	<x49sjegb7h4.fsf@segfault.boston.devel.redhat.com>
	<4FC7B491.9030105@micron.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 31 May 2012 14:40:22 -0400
In-Reply-To: <4FC7B491.9030105@micron.com> (Asai Thambi S. P.'s message of
	"Thu, 31 May 2012 11:12:33 -0700")
Message-ID: <x49hauwb3e1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> @@ -3631,7 +3631,11 @@ skip_create_disk:
>>>>>  	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
>>>>>  	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
>>>>>  	blk_queue_physical_block_size(dd->queue, 4096);
>>>>> +	blk_queue_max_hw_sectors(dd->queue, 0xffff);
>>>>> +	blk_queue_max_segment_size(dd->queue, 0x400000);
>>>>>  	blk_queue_io_min(dd->queue, 4096);
>>>>> +	dd->queue->nr_requests = 255;
>>>>
>>>> ->nr_requests isn't a boundary variable you set for the queue. It's set
>>>> by the core bits, or by the user via the sysfs interface.
>>>>
>>>> So you should not touch that from the driver.
>>>>
>>>
>>> Ok.
>>>
>>> I saw scsi lib module changing it, so thought of changing the value close to
>>> device queue depth.
>> 
>> That's actually a fair point.  What is the device queue depth for this
>> card?
>> 
> 256

Jens, I actually think changing nr_requests makes sense;  the only
question in my mind is where to do it.  (There's no point in artificially
limiting the device by default.)  IIRC, your general rule was to set this
value to 2x the device's queue depth.  So, given that this driver
doesn't use the blk-tag interfaces, what do you think would be the
cleanest way to bump nr_requests in this (and the more general) case?

Cheers,
Jeff
