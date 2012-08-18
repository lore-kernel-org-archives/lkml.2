Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab2HROJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 10:09:47 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:57934 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2HROJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 10:09:44 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
Date: Sat, 18 Aug 2012 23:09:36 +0900
In-Reply-To: <20120818132524.GW23464@ZenIV.linux.org.uk> (Al Viro's message of
	"Sat, 18 Aug 2012 14:25:24 +0100")
Message-ID: <87pq6op9zz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Aug 18, 2012 at 05:41:39AM -0400, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>> 
>> This patch-set eliminates the client side ESTALE errors when
>> a FAT partition exported over NFS has its dentries evicted 
>> from the cache.
>> 
>> One of the reasons for this error is lack of permanent inode 
>> numbers on FAT which makes it difficult to construct persistent 
>> file handles.This can be overcome by using the on-disk location
>> of the directory entries (i_pos) as the inode number.
>
> The hell it can.  You've just made them unstable on rename(2).

As more hint. We can't use i_pos as the inode number.

E.g. inode is unlinked but is still opened (orphaned inode), the dir
entry is free and you can create the inode on same i_pos. After that,
both inodes have same i_pos (so inode number).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
