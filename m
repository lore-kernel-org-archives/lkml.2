Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2IQNJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:09:44 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39655 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2IQNJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:09:43 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v3 0/5] fat: make persistent inode numbers and stablize for NFS.
References: <1347798099-2592-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 17 Sep 2012 22:09:33 +0900
In-Reply-To: <1347798099-2592-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 16 Sep 2012 08:21:39 -0400")
Message-ID: <87k3vs6bjm.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> This patch-set eliminates the client side ESTALE errors when a FAT partition
> exported over NFS has its dentries evicted from the cache.
>
> One of the reasons for this error is lack of permanent inode numbers on FAT
> which makes it difficult to construct persistent file handles.
> This can be overcome by using the on-disk location of the directory entries
> (i_pos) as the inode numbers.
>
> Once the i_pos is available, it is only a matter of reading the directory
> entries from the disk clusters to locate the matching entry and rebuild
> the corresponding inode.
>
> We reached the conclusion support stable inode's read-only export first after
> discussing with OGAWA and Bruce.
> And will make it writable with some operation(unlink and rename) limitation
> next time.
>
> Namjae Jeon (4)
>  fat: modify nfs mount option
>  fat: allocate persistent inode numbers
>  fat (exportfs): rebuild inode if ilookup() fails
>  fat (exportfs): rebuild directory-inode if fat_dget() fails
>  Documentation: update nfs option in filesystem/vfat.txt

Sorry for late, I will review at next weekend.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
