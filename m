Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1BQLun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:50:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42955 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab1BQLul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:50:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R1SGTk+uyJH3YHVnRjzwn74EBwjezAaVutkiYc8tsJWFXgcLkMZUc5QGbnEkyioMyj
         Urimzm+svAlbfiXLzWRpztIFDiy0sCwA0ZFDUW3v2uko32glO3cCN+rmn34nsQTdzrd6
         zA/oz4kSASPOY2nU5MKxuz6A0ja1SNXahk8p8=
MIME-Version: 1.0
In-Reply-To: <AANLkTim1wWi_sguqfo4t7V-RDT1tT41fkFtTVksoJGw5@mail.gmail.com>
References: <AANLkTim1wWi_sguqfo4t7V-RDT1tT41fkFtTVksoJGw5@mail.gmail.com>
Date: Thu, 17 Feb 2011 13:50:40 +0200
Message-ID: <AANLkTi=2Dk0Ewz472VyytJGbxui0jtnJHa_phB8eREEm@mail.gmail.com>
Subject: Re: [PATCH] code cleanup on include/linux/fs.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: torvalds <torvalds@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>,
        dchinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 11:37 AM, Steven Liu <lingjiujianke@gmail.com> wrote:
>     Cleanup the unsed code on  include/linux/fs.h.
>     All filesystem using mount_bdev and mount_nodev
>     to replace get_sb_bdev and get_sb_nodev.
>     So rmmove the unused code.

> -extern int get_sb_bdev(struct file_system_type *fs_type,
> -       int flags, const char *dev_name, void *data,
> -       int (*fill_super)(struct super_block *, void *, int),
> -       struct vfsmount *mnt);
>  extern struct dentry *mount_single(struct file_system_type *fs_type,
>        int flags, void *data,
>        int (*fill_super)(struct super_block *, void *, int));
> @@ -1821,10 +1817,6 @@ extern int get_sb_single(struct
> file_system_type *fs_type,
>  extern struct dentry *mount_nodev(struct file_system_type *fs_type,
>        int flags, void *data,
>        int (*fill_super)(struct super_block *, void *, int));
> -extern int get_sb_nodev(struct file_system_type *fs_type,
> -       int flags, void *data,
> -       int (*fill_super)(struct super_block *, void *, int),
> -       struct vfsmount *mnt);

The functions themselves are still in place, what's up?

fs/super.c:846:int get_sb_bdev(struct file_system_type *fs_type,
fs/super.c:861:EXPORT_SYMBOL(get_sb_bdev);
