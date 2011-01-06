Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1AFWFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:05:35 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:60640 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1AFWFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:05:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Zm+21xEhRSJKtowgX75dL34RdlWTqE0WROgikMKmtqAlV799rgRLjEuvMTSjATe3d5
         ixYKLJFsGLxA4PpETY9UQuRxrT8tGRh3mveuc7Wc2bkkyAK/+nV6jxodNX/MEOaxZjz6
         t2deOPeYmSSbQllbYmOoK5OhOrWFTHqt92bLE=
MIME-Version: 1.0
In-Reply-To: <4D26364E.8030909@lougher.demon.co.uk>
References: <4D26364E.8030909@lougher.demon.co.uk>
Date: Thu, 6 Jan 2011 23:05:31 +0100
X-Google-Sender-Auth: aEoAaCgY5NaO8FBvQJIFwNJEF84
Message-ID: <AANLkTikWF3NhoixFjND4WowZ1afzPF=qsRGsCkZWV5-B@mail.gmail.com>
Subject: Re: [PATCH 4/5] Squashfs: move squashfs_i() definition from squashfs.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 22:38, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
>
> Move squashfs_i() definition out of squashfs.h, this eliminates
> the need to #include squashfs_sb_i.h from numerous files.
                       ^^^^^^^^^^^^^^^
squashfs_fs_i.h?

> Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
> ---
>  fs/squashfs/block.c         |    1 -
>  fs/squashfs/cache.c         |    1 -
>  fs/squashfs/decompressor.c  |    1 -
>  fs/squashfs/fragment.c      |    1 -
>  fs/squashfs/id.c            |    1 -
>  fs/squashfs/lzo_wrapper.c   |    1 -
>  fs/squashfs/squashfs.h      |    5 -----
>  fs/squashfs/squashfs_fs_i.h |    6 ++++++
>  fs/squashfs/xattr_id.c      |    1 -
>  fs/squashfs/zlib_wrapper.c  |    1 -
>  10 files changed, 6 insertions(+), 13 deletions(-)
>
> diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
> index 653c030..2fb2882 100644
> --- a/fs/squashfs/block.c
> +++ b/fs/squashfs/block.c
> @@ -34,7 +34,6 @@
>
>  #include "squashfs_fs.h"
>  #include "squashfs_fs_sb.h"
> -#include "squashfs_fs_i.h"
>  #include "squashfs.h"
>  #include "decompressor.h"
>
> diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
> index 57314be..26b15ae 100644
> --- a/fs/squashfs/cache.c
> +++ b/fs/squashfs/cache.c
> @@ -55,7 +55,6 @@
>
>  #include "squashfs_fs.h"
>  #include "squashfs_fs_sb.h"
> -#include "squashfs_fs_i.h"
>  #include "squashfs.h"
>
>  /*
> diff --git a/fs/squashfs/decompressor.c b/fs/squashfs/decompressor.c
> index 24af9ce..d83e184 100644
> --- a/fs/squashfs/decompressor.c
> +++ b/fs/squashfs/decompressor.c
> @@ -27,7 +27,6 @@
>
>  #include "squashfs_fs.h"
>  #include "squashfs_fs_sb.h"
> -#include "squashfs_fs_i.h"
>  #include "decompressor.h"
>  #include "squashfs.h"
>
> diff --git a/fs/squashfs/fragment.c b/fs/squashfs/fragment.c
> index 7c90bbd..7eef571 100644
> --- a/fs/squashfs/fragment.c
> +++ b/fs/squashfs/fragment.c
> @@ -39,7 +39,6 @@
>
>  #include "squashfs_fs.h"
>  #include "squashfs_fs_sb.h"
> -#include "squashfs_fs_i.h"
>  #include "squashfs.h"
>
>  /*
> diff --git a/fs/squashfs/id.c b/fs/squashfs/id.c
> index b7f64bc..d8f3245 100644
> --- a/fs/squashfs/id.c
> +++ b/fs/squashfs/id.c
> @@ -37,7 +37,6 @@
>
>  #include "squashfs_fs.h"
>  #include "squashfs_fs_sb.h"
> -#include "squashfs_fs_i.h"
>  #include "squashfs.h"
>
>  /*
> diff --git a/fs/squashfs/lzo_wrapper.c b/fs/squashfs/lzo_wrapper.c
> index 5d87789..7da759e 100644
> --- a/fs/squashfs/lzo_wrapper.c
> +++ b/fs/squashfs/lzo_wrapper.c
> @@ -29,7 +29,6 @@
>
>  #include "squashfs_fs.h"
>  #include "squashfs_fs_sb.h"
> -#include "squashfs_fs_i.h"
>  #include "squashfs.h"
>  #include "decompressor.h"
>
> diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
> index 5d45569..18f187f 100644
> --- a/fs/squashfs/squashfs.h
> +++ b/fs/squashfs/squashfs.h
> @@ -27,11 +27,6 @@
>
>  #define WARNING(s, args...)    pr_warning("SQUASHFS: "s, ## args)
>
> -static inline struct squashfs_inode_info *squashfs_i(struct inode *inode)
> -{
> -       return list_entry(inode, struct squashfs_inode_info, vfs_inode);
> -}
> -
>  /* block.c */
>  extern int squashfs_read_data(struct super_block *, void **, u64, int, u64
> *,
>                                int, int);
> diff --git a/fs/squashfs/squashfs_fs_i.h b/fs/squashfs/squashfs_fs_i.h
> index d3e3a37..359baef 100644
> --- a/fs/squashfs/squashfs_fs_i.h
> +++ b/fs/squashfs/squashfs_fs_i.h
> @@ -45,4 +45,10 @@ struct squashfs_inode_info {
>        };
>        struct inode    vfs_inode;
>  };
> +
> +
> +static inline struct squashfs_inode_info *squashfs_i(struct inode *inode)
> +{
> +       return list_entry(inode, struct squashfs_inode_info, vfs_inode);
> +}
>  #endif
> diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
> index d33be5d..05385db 100644
> --- a/fs/squashfs/xattr_id.c
> +++ b/fs/squashfs/xattr_id.c
> @@ -32,7 +32,6 @@
>
>  #include "squashfs_fs.h"
>  #include "squashfs_fs_sb.h"
> -#include "squashfs_fs_i.h"
>  #include "squashfs.h"
>  #include "xattr.h"
>
> diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
> index ab5801f..818a5e0 100644
> --- a/fs/squashfs/zlib_wrapper.c
> +++ b/fs/squashfs/zlib_wrapper.c
> @@ -29,7 +29,6 @@
>
>  #include "squashfs_fs.h"
>  #include "squashfs_fs_sb.h"
> -#include "squashfs_fs_i.h"
>  #include "squashfs.h"
>  #include "decompressor.h"

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
