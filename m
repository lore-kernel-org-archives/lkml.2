Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2IFGaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:30:55 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63258 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2IFGax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:30:53 -0400
MIME-Version: 1.0
In-Reply-To: <87r4qg374w.fsf@devron.myhome.or.jp>
References: <1346774312-8142-1-git-send-email-linkinjeon@gmail.com>
	<87mx15910k.fsf@devron.myhome.or.jp>
	<87fw6x90o3.fsf@devron.myhome.or.jp>
	<CAKYAXd8Pspe0nobWedVfOwVYEKQsXx-Kbs1gWJm5F0ARgusTUw@mail.gmail.com>
	<87r4qg374w.fsf@devron.myhome.or.jp>
Date: Thu, 6 Sep 2012 15:30:52 +0900
Message-ID: <CAKYAXd8my3y9WXVwC0coYO=qTrSnGMoc+k14yx9t77tzJdax_g@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] fat: eliminate orphaned inode number allocation
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/5 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> 2012/9/5, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>>>
>>>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>>>
>>>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>>>
>>>>> Maintain a list of inode(i_pos) numbers of orphaned inodes (i.e the
>>>>> inodes that have been unlinked but still having open file
>>>>> descriptors).At file/directory creation time, skip using such i_pos
>>>>> values.Removal of the i_pos from the list is done during inode eviction.
>>>>
>>>> What happens if the directory (has busy entries) was completely removed?
>> Hi OGAWA.
>> There are 2 cases:
>> 1. The cluster can be used as a data cluster of a file - In which case
>> we can write
>> normally into it.
>> 2. The cluster can be allocated to a new directory. In this case, the busy i_pos
>> locations can not be used to create new entries until the correspnding
>> inodes are
>> evicted.
>
> In the (2) case, it has problem. Directory must not have de->name[0] == 0
> in middle of entires.  "0" means the end of directory.
Good point! I will fix it on next version of patches.
Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
