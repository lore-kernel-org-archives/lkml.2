Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab2KLGhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 01:37:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38983 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2KLGhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 01:37:22 -0500
MIME-Version: 1.0
In-Reply-To: <874nkw86jz.fsf@devron.myhome.or.jp>
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
	<874nkw86jz.fsf@devron.myhome.or.jp>
Date: Mon, 12 Nov 2012 15:37:20 +0900
Message-ID: <CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] fat: fix time updates for create and delete
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/12, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> Correctly update modification and status change time in case of
>> file/directory removal and creation.
>
> This changelog just explain "what", and it doesn't explain "why". Please
> explain why we need this change.
>
> IIRC, timestamp handling in FAT driver is strange historically. Anyway,
> FAT doesn't have "inode change time". It is "creation time" in FAT.
Hi. OGAWA.
I made this patch after comparing timestamp handlings with MSDOS and XFS.
Should timestamp handling of FAT be same with MSDOS ?
Am I missing ?

Thanks.
>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> ---
>>  fs/fat/dir.c        |    2 +-
>>  fs/fat/namei_vfat.c |    6 +++---
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
>> index 2a18234..c9fca7d 100644
>> --- a/fs/fat/dir.c
>> +++ b/fs/fat/dir.c
>> @@ -1042,7 +1042,7 @@ int fat_remove_entries(struct inode *dir, struct
>> fat_slot_info *sinfo)
>>  		}
>>  	}
>>
>> -	dir->i_mtime = dir->i_atime = CURRENT_TIME_SEC;
>> +	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
>>  	if (IS_DIRSYNC(dir))
>>  		(void)fat_sync_inode(dir);
>>  	else
>> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
>> index ac959d6..23bec0d 100644
>> --- a/fs/fat/namei_vfat.c
>> +++ b/fs/fat/namei_vfat.c
>> @@ -684,7 +684,7 @@ static int vfat_add_entry(struct inode *dir, struct
>> qstr *qname, int is_dir,
>>  		goto cleanup;
>>
>>  	/* update timestamp */
>> -	dir->i_ctime = dir->i_mtime = dir->i_atime = *ts;
>> +	dir->i_ctime = dir->i_mtime = *ts;
>>  	if (IS_DIRSYNC(dir))
>>  		(void)fat_sync_inode(dir);
>>  	else
>> @@ -826,7 +826,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry
>> *dentry)
>>  	drop_nlink(dir);
>>
>>  	clear_nlink(inode);
>> -	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
>> +	inode->i_ctime = CURRENT_TIME_SEC;
>>  	fat_detach(inode);
>>  out:
>>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);
>> @@ -851,7 +851,7 @@ static int vfat_unlink(struct inode *dir, struct
>> dentry *dentry)
>>  	if (err)
>>  		goto out;
>>  	clear_nlink(inode);
>> -	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
>> +	inode->i_ctime = CURRENT_TIME_SEC;
>>  	fat_detach(inode);
>>  out:
>>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
