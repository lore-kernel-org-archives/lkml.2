Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2HTETz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:19:55 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49169 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2HTETw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:19:52 -0400
MIME-Version: 1.0
In-Reply-To: <87pq6op9zz.fsf@devron.myhome.or.jp>
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
	<87pq6op9zz.fsf@devron.myhome.or.jp>
Date: Mon, 20 Aug 2012 13:19:51 +0900
Message-ID: <CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/18, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
>
>> On Sat, Aug 18, 2012 at 05:41:39AM -0400, Namjae Jeon wrote:
>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>
>>> This patch-set eliminates the client side ESTALE errors when
>>> a FAT partition exported over NFS has its dentries evicted
>>> from the cache.
>>>
>>> One of the reasons for this error is lack of permanent inode
>>> numbers on FAT which makes it difficult to construct persistent
>>> file handles.This can be overcome by using the on-disk location
>>> of the directory entries (i_pos) as the inode number.
>>
>> The hell it can.  You've just made them unstable on rename(2).
>
> As more hint. We can't use i_pos as the inode number.
>
> E.g. inode is unlinked but is still opened (orphaned inode), the dir
> entry is free and you can create the inode on same i_pos. After that,
> both inodes have same i_pos (so inode number).
>
> Thanks.
Hi. Ogawa.
Thanks for specific explanation. I will check it.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
