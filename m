Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab2EaP4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:56:51 -0400
Received: from masquerade.micron.com ([137.201.242.130]:49549 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2EaP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:56:48 -0400
Message-ID: <4FC794BD.1000309@micron.com>
Date: Thu, 31 May 2012 08:56:45 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 05/11] mtip32xx: Set block queue boundary variables
References: <4FC57B1B.5010901@micron.com> <4FC7130B.6040506@kernel.dk>
In-Reply-To: <4FC7130B.6040506@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18938.007
X-TM-AS-Result: No--14.151000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/2012 11:43 PM, Jens Axboe wrote:

> On 05/30/2012 03:42 AM, Asai Thambi S P wrote:
>>
>> Set the following block queue boundary variables
>> 	* max_hw_sectors
>> 	* max_segment_size
>> 	* nr_requests
>>
>> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
>> ---
>>  drivers/block/mtip32xx/mtip32xx.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
>> index 9fe897d..801e70c 100644
>> --- a/drivers/block/mtip32xx/mtip32xx.c
>> +++ b/drivers/block/mtip32xx/mtip32xx.c
>> @@ -3631,7 +3631,11 @@ skip_create_disk:
>>  	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
>>  	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
>>  	blk_queue_physical_block_size(dd->queue, 4096);
>> +	blk_queue_max_hw_sectors(dd->queue, 0xffff);
>> +	blk_queue_max_segment_size(dd->queue, 0x400000);
>>  	blk_queue_io_min(dd->queue, 4096);
>> +	dd->queue->nr_requests = 255;
> 
> ->nr_requests isn't a boundary variable you set for the queue. It's set
> by the core bits, or by the user via the sysfs interface.
> 
> So you should not touch that from the driver.
> 

Ok.

I saw scsi lib module changing it, so thought of changing the value close to
device queue depth.

--
Regards,
Asai Thambi
