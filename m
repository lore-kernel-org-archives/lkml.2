Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2K0LQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:16:07 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:35459 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab2K0LQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:16:06 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Reisner <dreisner@archlinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/fat: strip "cp" prefix from codepage in display
References: <1353702268-1568-1-git-send-email-dreisner@archlinux.org>
Date: Tue, 27 Nov 2012 20:16:01 +0900
In-Reply-To: <1353702268-1568-1-git-send-email-dreisner@archlinux.org> (Dave
	Reisner's message of "Fri, 23 Nov 2012 15:24:28 -0500")
Message-ID: <871ufffg9a.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Reisner <dreisner@archlinux.org> writes:

> Option parsing code expects an unsigned integer for the codepage option,
> but prefixes and stores this option with "cp" before passing to
> load_nls(). This makes the displayed option in /proc an invalid one.
> Strip the prefix when printing so that the displayed option is valid
> for reuse.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

But I think no guarantee, /proc/mounts can be used as mount command line.

> Signed-off-by: Dave Reisner <dreisner@archlinux.org>
> ---
>  fs/fat/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 5bafaad..f037feb 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -725,7 +725,8 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
>  	if (opts->allow_utime)
>  		seq_printf(m, ",allow_utime=%04o", opts->allow_utime);
>  	if (sbi->nls_disk)
> -		seq_printf(m, ",codepage=%s", sbi->nls_disk->charset);
> +		/* strip "cp" prefix from displayed option */
> +		seq_printf(m, ",codepage=%s", &sbi->nls_disk->charset[2]);
>  	if (isvfat) {
>  		if (sbi->nls_io)
>  			seq_printf(m, ",iocharset=%s", sbi->nls_io->charset);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
