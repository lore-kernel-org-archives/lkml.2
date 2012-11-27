Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2K0LPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:15:13 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:35458 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2K0LPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:15:11 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v5 0/8] fat: fix estale error on VFAT over NFS.
References: <1353504190-5766-1-git-send-email-linkinjeon@gmail.com>
Date: Tue, 27 Nov 2012 20:15:04 +0900
In-Reply-To: <1353504190-5766-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Wed, 21 Nov 2012 22:23:10 +0900")
Message-ID: <87624rfgav.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
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
> This can be overcome by using fat_encode_fh() that include i_pos in file handle.
>
> Once the i_pos is available, it is only a matter of reading the directory
> entries from the disk clusters to locate the matching entry and rebuild
> the corresponding inode.
>
> We reached the conclusion support stable inode's read-only export first after
> discussing with OGAWA and Bruce.
> And will make it writable with some operation(unlink and rename) limitation
> next time.

I will review at this weekend. sorry.

> Namjae Jeon (8)
>  fat: modify nfs mount option
>  fat: move fat_i_pos_read to fat.h
>  fat: pass superblock pointer instead of inode pointer to fat_ent_read()
>  fat: introduce a helper fat_get_blknr_offset()
>  fat: restructure export_operations
>  fat (exportfs): rebuild inode if ilookup() fails
>  fat (exportfs): rebuild directory-inode if fat_dget() fails
>  Documentation: update nfs option in filesystem/vfat.txt
>
> ---
> 1.7.9.5
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
