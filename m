Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab0HCSwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:52:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58447 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab0HCSwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:52:20 -0400
MIME-Version: 1.0
In-Reply-To: <20100803115041.101630be.randy.dunlap@oracle.com>
References: <20100802.160057.91342787.davem@davemloft.net>
	<1280803966-11603-1-git-send-email-wad@chromium.org>
	<20100803115041.101630be.randy.dunlap@oracle.com>
Date: Tue, 3 Aug 2010 13:52:18 -0500
Message-ID: <AANLkTimawZaz5i+5ga0_tNuybYLiWHX9tZ9UJyZmSogO@mail.gmail.com>
Subject: Re: [PATCH v2 RFC] efi: add and expose efi_partition_by_guid
From: Will Drewry <wad@chromium.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 1:50 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon,  2 Aug 2010 21:52:46 -0500 Will Drewry wrote:
>
>
>> v2: pr_debug(KERN_WARNING -> pr_debug(. joe@perches.com
>>     moved down trailing {. davem@davemloft.net
>
> Eh?  see below.
>
>> ---
>>  fs/partitions/efi.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/efi.h |    5 ++++
>>  2 files changed, 66 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
>> index 9efb2cf..8669c4f 100644
>> --- a/fs/partitions/efi.c
>> +++ b/fs/partitions/efi.c
>> @@ -633,3 +633,64 @@ int efi_partition(struct parsed_partitions *state)
>>       printk("\n");
>>       return 1;
>>  }
>> +
>> +/**
>> + * efi_partition_by_guid
>> + * @bdev:    Whole block device to scan for a GPT.
>> + * @guid:    Unique identifier for the partition to find.
>> + *
>> + * N.b., returns on the first match since it should be unique.
>> + *
>> + * Returns:
>> + * -1 if an error occurred
>> + *  0 if there was no match (or not GPT)
>> + *  >=1 is the index of the partition found.
>> + *
>> + */
>> +int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid) {
>
> That opening brace should be on a line by itself:
>
> int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid)
> {

Thanks - yeah I failed to git commit --amend properly on the second posting :/

> and the kernel-doc function description should be like so:
>
> /**
>  * efi_partition_by_guid - find the first (only) matching guid on a block device
>
> or some such short function description.

I'll be sure to use the proper format on the next patch round!

thanks!
