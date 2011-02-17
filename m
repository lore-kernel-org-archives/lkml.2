Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1BQL6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:58:17 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53210 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab1BQL6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:58:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kWqKxcpt9QPucEApw5ik0qtRGuBL561AYItrhdfKuacGhvxVtckwXJbgRT5qsFDt+X
         IPjs8rfgPj/jF3FnhMIYU20FNAVKtC+jJ6QKIHPyw9JTGvO3dik2jwOZBkb7Z/pkYQoj
         I66X+oqH381QATgo9NATojBq2Al4h0MJ24wyY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=2Dk0Ewz472VyytJGbxui0jtnJHa_phB8eREEm@mail.gmail.com>
References: <AANLkTim1wWi_sguqfo4t7V-RDT1tT41fkFtTVksoJGw5@mail.gmail.com>
	<AANLkTi=2Dk0Ewz472VyytJGbxui0jtnJHa_phB8eREEm@mail.gmail.com>
Date: Thu, 17 Feb 2011 19:58:14 +0800
Message-ID: <AANLkTinfwNWkr05p5d1ji_qfdSZo1sn-X5FtnjF37dTa@mail.gmail.com>
Subject: Re: [PATCH] code cleanup on include/linux/fs.h
From: Steven Liu <lingjiujianke@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds <torvalds@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>,
        dchinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Alexey Dobriyan,

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 fs/super.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 7e9dd4c..8272f26 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -843,22 +843,6 @@ error:
 }
 EXPORT_SYMBOL(mount_bdev);

-int get_sb_bdev(struct file_system_type *fs_type,
-       int flags, const char *dev_name, void *data,
-       int (*fill_super)(struct super_block *, void *, int),
-       struct vfsmount *mnt)
-{
-       struct dentry *root;
-
-       root = mount_bdev(fs_type, flags, dev_name, data, fill_super);
-       if (IS_ERR(root))
-               return PTR_ERR(root);
-       mnt->mnt_root = root;
-       mnt->mnt_sb = root->d_sb;
-       return 0;
-}
-
-EXPORT_SYMBOL(get_sb_bdev);

 void kill_block_super(struct super_block *sb)
 {
@@ -897,21 +881,6 @@ struct dentry *mount_nodev(struct
file_system_type *fs_type,
 }
 EXPORT_SYMBOL(mount_nodev);

-int get_sb_nodev(struct file_system_type *fs_type,
-       int flags, void *data,
-       int (*fill_super)(struct super_block *, void *, int),
-       struct vfsmount *mnt)
-{
-       struct dentry *root;
-
-       root = mount_nodev(fs_type, flags, data, fill_super);
-       if (IS_ERR(root))
-               return PTR_ERR(root);
-       mnt->mnt_root = root;
-       mnt->mnt_sb = root->d_sb;
-       return 0;
-}
-EXPORT_SYMBOL(get_sb_nodev);

 static int compare_single(struct super_block *s, void *p)
 {
--
1.6.5.2




Best Regards


Steven Liu

2011/2/17 Alexey Dobriyan <adobriyan@gmail.com>:
> On Thu, Feb 17, 2011 at 11:37 AM, Steven Liu <lingjiujianke@gmail.com> wrote:
>>     Cleanup the unsed code on  include/linux/fs.h.
>>     All filesystem using mount_bdev and mount_nodev
>>     to replace get_sb_bdev and get_sb_nodev.
>>     So rmmove the unused code.
>
>> -extern int get_sb_bdev(struct file_system_type *fs_type,
>> -       int flags, const char *dev_name, void *data,
>> -       int (*fill_super)(struct super_block *, void *, int),
>> -       struct vfsmount *mnt);
>>  extern struct dentry *mount_single(struct file_system_type *fs_type,
>>        int flags, void *data,
>>        int (*fill_super)(struct super_block *, void *, int));
>> @@ -1821,10 +1817,6 @@ extern int get_sb_single(struct
>> file_system_type *fs_type,
>>  extern struct dentry *mount_nodev(struct file_system_type *fs_type,
>>        int flags, void *data,
>>        int (*fill_super)(struct super_block *, void *, int));
>> -extern int get_sb_nodev(struct file_system_type *fs_type,
>> -       int flags, void *data,
>> -       int (*fill_super)(struct super_block *, void *, int),
>> -       struct vfsmount *mnt);
>
> The functions themselves are still in place, what's up?
>
> fs/super.c:846:int get_sb_bdev(struct file_system_type *fs_type,
> fs/super.c:861:EXPORT_SYMBOL(get_sb_bdev);
>
