Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2GHKiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 06:38:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50226 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2GHKix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 06:38:53 -0400
Message-ID: <4FF96332.8080401@gmail.com>
Date: Sun, 08 Jul 2012 18:38:42 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Zheng Liu <gnehzuil.liu@gmail.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: fix the comment in ext4_ext_insert_extent for
 ext4_ext_try_to_merge in extents.c
References: <4FF68511.9050207@gmail.com> <CANWLp03uEyPZUbUD+rO=AtRQPLVSvTMTJERhCX94Nfw-7QRtmQ@mail.gmail.com>
In-Reply-To: <CANWLp03uEyPZUbUD+rO=AtRQPLVSvTMTJERhCX94Nfw-7QRtmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年07月07日 23:15, Zheng Liu wrote:
> Hi Sheng-Hui,
> 
> It seems that there has a patch to fix it.
> http://www.spinics.net/lists/linux-ext4/msg32611.html
> 
> Regards,
> Zheng

Got it. 

I didn't track the patch list. Just checked the git tree.

Thanks,

> 
> On Fri, Jul 6, 2012 at 2:26 PM, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
>> The left and right extents merge is done by
>> ext4_ext_try_to_merge. No specific left/right
>> fun calls any more.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/ext4/extents.c |    4 +---
>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 5207b7b..6c2a37d 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -1891,12 +1891,10 @@ has_space:
>>         nearex->ee_len = newext->ee_len;
>>
>>  merge:
>> -       /* try to merge extents to the right */
>> +       /* try to merge extents to the neighbours */
>>         if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
>>                 ext4_ext_try_to_merge(inode, path, nearex);
>>
>> -       /* try to merge extents to the left */
>> -
>>         /* time to correct all indexes above */
>>         err = ext4_ext_correct_indexes(handle, inode, path);
>>         if (err)
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

