Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023Ab2JLM7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 08:59:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41890 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933Ab2JLM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 08:59:51 -0400
MIME-Version: 1.0
In-Reply-To: <20121011175408.GB18391@quack.suse.cz>
References: <1349795368-6425-1-git-send-email-linkinjeon@gmail.com>
	<20121011175408.GB18391@quack.suse.cz>
Date: Fri, 12 Oct 2012 21:59:50 +0900
Message-ID: <CAKYAXd95aqHf5AioJfHWRDYVHHu=DCV4G_zLPX+1f8cZPKxCAA@mail.gmail.com>
Subject: Re: [PATCH 3/6] udf: update inode's iblock count when allocating new block
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/12 Jan Kara <jack@suse.cz>:
> On Wed 10-10-12 00:09:28, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Currently, du will show wrong block count. This patch fix it.
>   This should be fixed by commit fd4287dbc07763595c1e74edbb6520092290185c.
> Have you tested with newish kernel? If recent kernel still has an issue,
> can you provide a test case? Thanks!
Hi. Jan.
You're right. There is no issue with latest kernel.
Plz ignore this patch.
Thanks a lot!
>
>                                                                 Honza
>
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> ---
>>  fs/udf/inode.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
>> index 8266f2e..76a1f57 100644
>> --- a/fs/udf/inode.c
>> +++ b/fs/udf/inode.c
>> @@ -775,6 +775,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>>               if (isBeyondEOF)
>>                       iinfo->i_lenExtents += inode->i_sb->s_blocksize;
>>       }
>> +     /* update inode's iblocks */
>> +     inode->i_blocks += (1 << (inode->i_sb->s_blocksize_bits - 9));
>>
>>       /* if the extent the requsted block is located in contains multiple
>>        * blocks, split the extent into at most three extents. blocks prior
>> --
>> 1.7.9.5
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
