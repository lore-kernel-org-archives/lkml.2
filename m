Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2CVN0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 09:26:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33482 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab2CVN0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 09:26:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120322003356.GT6589@ZenIV.linux.org.uk>
References: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com>
	<20120322003356.GT6589@ZenIV.linux.org.uk>
Date: Thu, 22 Mar 2012 21:26:11 +0800
Message-ID: <CAJd=RBC=ajApxw_+tfOoY9KpTNW2Y+_B5MxDOjBH3Y5-PDW2jg@mail.gmail.com>
Subject: Re: [PATCH] hugetlbfs: add err code in initializing module
From: Hillf Danton <dhillf@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 8:33 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Mar 11, 2012 at 01:09:59PM +0800, Hillf Danton wrote:
>> Error code is added if fail to create inode kmem cache, and newly registered
>> hugetlb FS is unregistered if fail to mount, both for unlikely corner cases.
>>
>> --- a/fs/hugetlbfs/inode.c    Sun Mar 11 12:46:38 2012
>> +++ b/fs/hugetlbfs/inode.c    Sun Mar 11 12:49:28 2012
>> @@ -1000,6 +1000,7 @@ static int __init init_hugetlbfs_fs(void
>>       hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
>>                                       sizeof(struct hugetlbfs_inode_info),
>>                                       0, 0, init_once);
>> +     error = -ENOMEM;
>>       if (hugetlbfs_inode_cachep == NULL)
>>               goto out2;
>>
>> @@ -1015,6 +1016,7 @@ static int __init init_hugetlbfs_fs(void
>>       }
>>
>>       error = PTR_ERR(vfsmount);
>> +     unregister_filesystem(&hugetlbfs_fs_type);
>
> Bloody bad idea, that...  Realistically, the proper action on failure here
> (as well as in sock_init(), etc.) is panic().  If we fail to OOM that early,
> the box is doomed anyway.
>
> Note that unregister_filesystem() in module init is *always* wrong; it's not
> an issue here (it's done too early to care about and realistically the box
> is not going anywhere - it'll panic when attempt to exec /sbin/init fails,
> if not earlier), but it's a damn bad example.
>
Thanks for your review, Al.

Due to bad idea and bad example, please issue Nack, then the patch
that was not well prepared will be dropped.

-hd
