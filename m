Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0KEJPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 05:15:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40040 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0KEJPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D/cd1p5qfJdkMdJyoNwe5tbeQYKfB3Y0DG5iPBx0POJDtD6z7dJVHSFEItkea9YBsD
         xoRqO6VA9L7Ifi6vIJ1plzy0hJ2KkYROEA53tXCG5T1cJJIJxRqKmqTPq0W7HSKG7c1I
         5LVKb8nL/K0eydbanunoldE+03uDTH9b+6Kfw=
MIME-Version: 1.0
In-Reply-To: <20101105091117.GA5033@quack.suse.cz>
References: <cover.1288925424.git.joe@perches.com>
	<a47fec6f62a102773e28984b86f34525fd42b540.1288925425.git.joe@perches.com>
	<20101105091117.GA5033@quack.suse.cz>
Date: Fri, 5 Nov 2010 10:15:15 +0100
Message-ID: <AANLkTi=gibTo_cC83AV2QmQgh4kDiPsA1taCm4NXztYs@mail.gmail.com>
Subject: Re: [PATCH 40/49] fs/udf: Use vzalloc
From: Peter Bortas <bortas@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 5, 2010 at 10:11 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 04-11-10 20:08:04, Joe Perches wrote:
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  fs/udf/super.c |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>  I've merged the patch into my tree.
>
>                                                        Honza
>
>>
>> diff --git a/fs/udf/super.c b/fs/udf/super.c
>> index 4a5c7c6..6e07d99 100644
>> --- a/fs/udf/super.c
>> +++ b/fs/udf/super.c
>> @@ -959,9 +959,9 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
>>               (sizeof(struct buffer_head *) * nr_groups);
>>
>>       if (size <= PAGE_SIZE)
>> -             bitmap = kmalloc(size, GFP_KERNEL);
>> +             bitmap = kzalloc(size, GFP_KERNEL);
>>       else
>> -             bitmap = vmalloc(size); /* TODO: get rid of vmalloc */
>> +             bitmap = vzalloc(size); /* TODO: get rid of vmalloc */

Shouldn't this comment be removed or at least changed to match the new malloc?

>>
>>       if (bitmap == NULL) {
>>               udf_error(sb, __func__,
>> @@ -970,7 +970,6 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
>>               return NULL;
>>       }
>>
>> -     memset(bitmap, 0x00, size);
>>       bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
>>       bitmap->s_nr_groups = nr_groups;
>>       return bitmap;
>> --
>> 1.7.3.1.g432b3.dirty
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

-- 
Peter Bortas
