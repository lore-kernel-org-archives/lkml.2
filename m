Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2IEN4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:56:52 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35722 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2IEN4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:56:51 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 4/5] fat: eliminate orphaned inode number allocation
References: <1346774312-8142-1-git-send-email-linkinjeon@gmail.com>
	<87mx15910k.fsf@devron.myhome.or.jp>
	<87fw6x90o3.fsf@devron.myhome.or.jp>
	<CAKYAXd8Pspe0nobWedVfOwVYEKQsXx-Kbs1gWJm5F0ARgusTUw@mail.gmail.com>
Date: Wed, 05 Sep 2012 22:56:47 +0900
In-Reply-To: <CAKYAXd8Pspe0nobWedVfOwVYEKQsXx-Kbs1gWJm5F0ARgusTUw@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 5 Sep 2012 22:37:41 +0900")
Message-ID: <87r4qg374w.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 2012/9/5, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>>
>>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>>
>>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>>
>>>> Maintain a list of inode(i_pos) numbers of orphaned inodes (i.e the
>>>> inodes that have been unlinked but still having open file
>>>> descriptors).At file/directory creation time, skip using such i_pos
>>>> values.Removal of the i_pos from the list is done during inode eviction.
>>>
>>> What happens if the directory (has busy entries) was completely removed?
> Hi OGAWA.
> There are 2 cases:
> 1. The cluster can be used as a data cluster of a file - In which case
> we can write
> normally into it.
> 2. The cluster can be allocated to a new directory. In this case, the busy i_pos
> locations can not be used to create new entries until the correspnding
> inodes are
> evicted.

In the (2) case, it has problem. Directory must not have de->name[0] == 0
in middle of entires.  "0" means the end of directory.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
