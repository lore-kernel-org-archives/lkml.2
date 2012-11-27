Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2K0L0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:26:45 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51893 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2K0L0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <87624rfgav.fsf@devron.myhome.or.jp>
References: <1353504190-5766-1-git-send-email-linkinjeon@gmail.com>
	<87624rfgav.fsf@devron.myhome.or.jp>
Date: Tue, 27 Nov 2012 20:26:43 +0900
Message-ID: <CAKYAXd8wzBnf7M-ruOc-=qtGcUWEBMBP6QNEwBrM5BzmdHD+PQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] fat: fix estale error on VFAT over NFS.
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch-set eliminates the client side ESTALE errors when a FAT
>> partition
>> exported over NFS has its dentries evicted from the cache.
>>
>> One of the reasons for this error is lack of permanent inode numbers on
>> FAT
>> which makes it difficult to construct persistent file handles.
>> This can be overcome by using fat_encode_fh() that include i_pos in file
>> handle.
>>
>> Once the i_pos is available, it is only a matter of reading the directory
>> entries from the disk clusters to locate the matching entry and rebuild
>> the corresponding inode.
>>
>> We reached the conclusion support stable inode's read-only export first
>> after
>> discussing with OGAWA and Bruce.
>> And will make it writable with some operation(unlink and rename)
>> limitation
>> next time.
>
> I will review at this weekend. sorry.
No problem. I will wait.
Thanks for reply.
>
>> Namjae Jeon (8)
>>  fat: modify nfs mount option
>>  fat: move fat_i_pos_read to fat.h
>>  fat: pass superblock pointer instead of inode pointer to fat_ent_read()
>>  fat: introduce a helper fat_get_blknr_offset()
>>  fat: restructure export_operations
>>  fat (exportfs): rebuild inode if ilookup() fails
>>  fat (exportfs): rebuild directory-inode if fat_dget() fails
>>  Documentation: update nfs option in filesystem/vfat.txt
>>
>> ---
>> 1.7.9.5
>>
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
