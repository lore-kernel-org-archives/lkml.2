Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab2IENhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:37:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46126 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab2IENhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:37:42 -0400
MIME-Version: 1.0
In-Reply-To: <87fw6x90o3.fsf@devron.myhome.or.jp>
References: <1346774312-8142-1-git-send-email-linkinjeon@gmail.com>
	<87mx15910k.fsf@devron.myhome.or.jp>
	<87fw6x90o3.fsf@devron.myhome.or.jp>
Date: Wed, 5 Sep 2012 22:37:41 +0900
Message-ID: <CAKYAXd8Pspe0nobWedVfOwVYEKQsXx-Kbs1gWJm5F0ARgusTUw@mail.gmail.com>
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

2012/9/5, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>
>>> Maintain a list of inode(i_pos) numbers of orphaned inodes (i.e the
>>> inodes that have been unlinked but still having open file
>>> descriptors).At file/directory creation time, skip using such i_pos
>>> values.Removal of the i_pos from the list is done during inode eviction.
>>
>> What happens if the directory (has busy entries) was completely removed?
Hi OGAWA.
There are 2 cases:
1. The cluster can be used as a data cluster of a file - In which case
we can write
normally into it.
2. The cluster can be allocated to a new directory. In this case, the busy i_pos
locations can not be used to create new entries until the correspnding
inodes are
evicted.

>>
>>
>> And Al's point is important for NFS too. If you want stable ino for NFS,
>> you never can't change it.
Yes, It is also important, I will explain throughout reply in Al's mail.
Thanks!
>
> s/never can't/never can/
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
