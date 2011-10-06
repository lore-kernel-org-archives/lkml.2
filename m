Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935636Ab1JFAdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:33:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58925 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935355Ab1JFAdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <20111005221442.GL23467@quack.suse.cz>
References: <1317618179-22176-1-git-send-email-linkinjeon@gmail.com>
	<20111005221442.GL23467@quack.suse.cz>
Date: Thu, 6 Oct 2011 09:33:36 +0900
Message-ID: <CAKYAXd-fu3aLAm3nPHrwsR_9LLa8Aeg94cpaY38bXZ1a5YC4kA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] udf : add readpages support for udf.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/6 Jan Kara <jack@suse.cz>:
> On Mon 03-10-11 14:02:59, Namjae Jeon wrote:
>> Using mpage_readpages instead of multiple calls to udf_readpage to reduce the CPU utilization and make performance higher.
>  Thanks. I've merged this patch.
Hi. Jan.
this patch is created by the second from [PATCH 1/2 v3] udf : enable
error print in udf_read_tagged().
So if hunk or problem happen, plz inform me it.
Thanks a lot.
>
>                                                                        Honza
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>>  fs/udf/inode.c |   10 +++++++++-
>>  1 files changed, 9 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
>> index 58665ce..81f9ce1 100644
>> --- a/fs/udf/inode.c
>> +++ b/fs/udf/inode.c
>> @@ -37,6 +37,7 @@
>>  #include <linux/writeback.h>
>>  #include <linux/slab.h>
>>  #include <linux/crc-itu-t.h>
>> +#include <linux/mpage.h>
>>
>>  #include "udf_i.h"
>>  #include "udf_sb.h"
>> @@ -104,7 +105,13 @@ static int udf_writepage(struct page *page, struct writeback_control *wbc)
>>
>>  static int udf_readpage(struct file *file, struct page *page)
>>  {
>> -     return block_read_full_page(page, udf_get_block);
>> +     return mpage_readpage(page, udf_get_block);
>> +}
>> +
>> +static int udf_readpages(struct file *file, struct address_space *mapping,
>> +                     struct list_head *pages, unsigned nr_pages)
>> +{
>> +     return mpage_readpages(mapping, pages, nr_pages, udf_get_block);
>>  }
>>
>>  static int udf_write_begin(struct file *file, struct address_space *mapping,
>> @@ -139,6 +146,7 @@ static sector_t udf_bmap(struct address_space *mapping, sector_t block)
>>
>>  const struct address_space_operations udf_aops = {
>>       .readpage       = udf_readpage,
>> +     .readpages      = udf_readpages,
>>       .writepage      = udf_writepage,
>>       .write_begin            = udf_write_begin,
>>       .write_end              = generic_write_end,
>> --
>> 1.7.4.4
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
