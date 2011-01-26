Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1AZTJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:09:17 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56634 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1AZTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:09:16 -0500
Date: Wed, 26 Jan 2011 13:09:08 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] zram: Prevent overflow in logical block size
Message-ID: <20110126190908.GE17383@linux.vnet.ibm.com>
Mail-Followup-To: Pekka Enberg <penberg@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikLCJXhVG9FRmmYznRG+9Gz4U8m-SoeasZyPy39@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@kernel.org> wrote:
> On Wed, Jan 26, 2011 at 7:23 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
>> On a 64K page kernel, the value PAGE_SIZE passed to
>> blk_queue_logical_block_size would overflow the logical block size
>> argument (resulting in setting it to 0).
>> 
>> Take the minimum of PAGE_SIZE or 4096 and use this for the block device
>> logical block size.
>> 
>> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
>> ---
>>  drivers/staging/zram/zram_drv.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index d0e9e02..d5e0275 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -621,7 +621,8 @@ static int create_device(struct zram *zram, int device_id)
>>  	 * and n*PAGE_SIZED sized I/O requests.
>>  	 */
>>  	blk_queue_physical_block_size(zram->disk->queue, PAGE_SIZE);
>> -	blk_queue_logical_block_size(zram->disk->queue, PAGE_SIZE);
>> +	blk_queue_logical_block_size(zram->disk->queue,
>> +			(unsigned short) min_t(unsigned int, PAGE_SIZE, 4096));
> 
> I don't get it. No architecture supports PAGE_SIZE less than 4K so
> that expression always ends up being 4096, no?

Yes, I will cut out the min_t and just hard-code this to 4096.
