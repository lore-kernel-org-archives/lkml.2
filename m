Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1AZTO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:14:59 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34677 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1AZTO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=q9PBCcVs3KKWDOgg02jcOe2UNrF50GDl3SpwDiNlwcdtP+zrqdGm/vEnXwn+nY43Jw
         e0HFD4YxXOl2Ebi2H+mdWcqGtRHpP28vvkHzktuY3b/V5C9C7+/k7Ii7Eg9MsZufiIHG
         Wc8PoR/DMr+FzePvDl0XjV65BW/JNY4IzINkU=
MIME-Version: 1.0
In-Reply-To: <20110126190908.GE17383@linux.vnet.ibm.com>
References: <AANLkTikLCJXhVG9FRmmYznRG+9Gz4U8m-SoeasZyPy39@mail.gmail.com>
	<20110126190908.GE17383@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 21:14:57 +0200
X-Google-Sender-Auth: g43YYrwoJjanR7Zw8kJ1_VfpM4w
Message-ID: <AANLkTim-Z_FCn7R_KRjfisKmR00ybrHYBxRSn8_uYF6F@mail.gmail.com>
Subject: Re: [PATCH 2/7] zram: Prevent overflow in logical block size
From: Pekka Enberg <penberg@kernel.org>
To: Pekka Enberg <penberg@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 9:09 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> Pekka Enberg <penberg@kernel.org> wrote:
>> On Wed, Jan 26, 2011 at 7:23 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
>>> On a 64K page kernel, the value PAGE_SIZE passed to
>>> blk_queue_logical_block_size would overflow the logical block size
>>> argument (resulting in setting it to 0).
>>>
>>> Take the minimum of PAGE_SIZE or 4096 and use this for the block device
>>> logical block size.
>>>
>>> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
>>> ---
>>>  drivers/staging/zram/zram_drv.c |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>>> index d0e9e02..d5e0275 100644
>>> --- a/drivers/staging/zram/zram_drv.c
>>> +++ b/drivers/staging/zram/zram_drv.c
>>> @@ -621,7 +621,8 @@ static int create_device(struct zram *zram, int device_id)
>>>       * and n*PAGE_SIZED sized I/O requests.
>>>       */
>>>      blk_queue_physical_block_size(zram->disk->queue, PAGE_SIZE);
>>> -    blk_queue_logical_block_size(zram->disk->queue, PAGE_SIZE);
>>> +    blk_queue_logical_block_size(zram->disk->queue,
>>> +                    (unsigned short) min_t(unsigned int, PAGE_SIZE, 4096));
>>
>> I don't get it. No architecture supports PAGE_SIZE less than 4K so
>> that expression always ends up being 4096, no?
>
> Yes, I will cut out the min_t and just hard-code this to 4096.

Please make a ZRAM_BLOCK_SIZE constant or something for that.
