Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1KEJCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 05:02:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47235 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1KEJCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 05:02:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2UW0fOQD0V04QsQf7zLEn_v2ScNArajA7YrbXUmN2RXYg@mail.gmail.com>
References: <1320472196-1987-1-git-send-email-linkinjeon@gmail.com>
	<CAH9JG2UW0fOQD0V04QsQf7zLEn_v2ScNArajA7YrbXUmN2RXYg@mail.gmail.com>
Date: Sat, 5 Nov 2011 18:02:33 +0900
Message-ID: <CAKYAXd-d9=U7UijE7w7Ca2_DDTS7J4CALQnbuduBvrcXQVBHhA@mail.gmail.com>
Subject: Re: [PATCH] ext4: add blk_finish_plug in error case of writepages.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/5 Kyungmin Park <kmpark@infradead.org>:
> It's already fixed after finding the bug by original author.
>
> Thank you,
> Kyungmin Park
Hi. Park.
This bug is not fixed yet on the latest git of ted,
Do I know to be wrong ?
Thanks.
>
> On Sat, Nov 5, 2011 at 2:49 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>> blk_finish_plug is needed in error case of writepages.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>>  fs/ext4/inode.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index cc5a6da..18b262b 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -2270,6 +2270,7 @@ retry:
>>                        ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
>>                               "%ld pages, ino %lu; err %d", __func__,
>>                                wbc->nr_to_write, inode->i_ino, ret);
>> +                       blk_finish_plug(&plug);
>>                        goto out_writepages;
>>                }
>>
>> --
>> 1.7.4.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
