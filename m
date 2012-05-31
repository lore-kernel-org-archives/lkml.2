Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2EaSI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab2EaSI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:08:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 05/11] mtip32xx: Set block queue boundary variables
References: <4FC57B1B.5010901@micron.com> <4FC7130B.6040506@kernel.dk>
	<4FC794BD.1000309@micron.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 31 May 2012 13:12:07 -0400
In-Reply-To: <4FC794BD.1000309@micron.com> (Asai Thambi S. P.'s message of
	"Thu, 31 May 2012 08:56:45 -0700")
Message-ID: <x49sjegb7h4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asai Thambi S P <asamymuthupa@micron.com> writes:

> On 5/30/2012 11:43 PM, Jens Axboe wrote:
>
>> On 05/30/2012 03:42 AM, Asai Thambi S P wrote:
>>>
>>> Set the following block queue boundary variables
>>> 	* max_hw_sectors
>>> 	* max_segment_size
>>> 	* nr_requests
>>>
>>> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
>>> ---
>>>  drivers/block/mtip32xx/mtip32xx.c |    4 ++++
>>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
>>> index 9fe897d..801e70c 100644
>>> --- a/drivers/block/mtip32xx/mtip32xx.c
>>> +++ b/drivers/block/mtip32xx/mtip32xx.c
>>> @@ -3631,7 +3631,11 @@ skip_create_disk:
>>>  	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
>>>  	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
>>>  	blk_queue_physical_block_size(dd->queue, 4096);
>>> +	blk_queue_max_hw_sectors(dd->queue, 0xffff);
>>> +	blk_queue_max_segment_size(dd->queue, 0x400000);
>>>  	blk_queue_io_min(dd->queue, 4096);
>>> +	dd->queue->nr_requests = 255;
>> 
>> ->nr_requests isn't a boundary variable you set for the queue. It's set
>> by the core bits, or by the user via the sysfs interface.
>> 
>> So you should not touch that from the driver.
>> 
>
> Ok.
>
> I saw scsi lib module changing it, so thought of changing the value close to
> device queue depth.

That's actually a fair point.  What is the device queue depth for this
card?

Cheers,
Jeff
