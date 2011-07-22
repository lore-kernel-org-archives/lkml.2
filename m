Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1GVLjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:39:04 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61568 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1GVLjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:39:01 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87y5zqfxt1.fsf@tucsk.pomaz.szeredi.hu>
References: <CA+icZUVbeLU+zCAC+8wduizn6h5FUE2qzNr0bg9t3yWNbv_6Ng@mail.gmail.com>
	<CA+icZUXf1_qWF8GdQyCVxzAp-CYgQbH8iod0oBTjhWsSZLi1_g@mail.gmail.com>
	<87y5zqfxt1.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 22 Jul 2011 13:38:59 +0200
Message-ID: <CA+icZUWKaOKk0xSMDWi5hprELjhTQgDpLwVJM6OXmAnNX3oNLg@mail.gmail.com>
Subject: Re: linux-next: Tree for July 20 (overlayfs)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 11:51 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
[ ... ]
> And ->fsync is another one that will have an updated API.
>
> Miklos
>
> ---
>  fs/overlayfs/readdir.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/fs/overlayfs/readdir.c
> ===================================================================
> --- linux-2.6.orig/fs/overlayfs/readdir.c       2011-07-21 17:07:52.000000000 +0200
> +++ linux-2.6/fs/overlayfs/readdir.c    2011-07-21 17:10:20.000000000 +0200
> @@ -386,7 +386,8 @@ static loff_t ovl_dir_llseek(struct file
>        return res;
>  }
>
> -static int ovl_dir_fsync(struct file *file, int datasync)
> +static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
> +                        int datasync)
>  {
>        struct ovl_dir_file *od = file->private_data;
>
> @@ -400,7 +401,7 @@ static int ovl_dir_fsync(struct file *fi
>                        return PTR_ERR(od->realfile);
>        }
>
> -       return vfs_fsync(od->realfile, datasync);
> +       return vfs_fsync_range(od->realfile, start, end, datasync);
>  }
>
>  static int ovl_dir_release(struct inode *inode, struct file *file)
>

OK, I see your patch is like mine due to changes in linux-next (here:
I checked with next-20110721):

commit cbc4facd43b3502f644d7f01a9a48f8bec5f3e57
"fs: push i_mutex and filemap_write_and_wait down into ->fsync() handlers"

Is it possible to have a clean...

1. OverlayFS v11 against Linux-3.0
2. OverlayFS v11 against vfs-2.6.git#for-next (see [2])

- Sedat -

[1] <http://git.us.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commit;h=cbc4facd43b3502f644d7f01a9a48f8bec5f3e57>
[2]  <http://git.us.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=shortlog;h=refs/heads/for-next>
