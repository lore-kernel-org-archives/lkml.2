Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3ABSdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:33:50 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48934 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3ABSdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:33:46 -0500
Date: Wed, 2 Jan 2013 10:33:51 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Reisner <dreisner@archlinux.org>, keescook@chromium.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: convert gid= argument from decimal, not octal
Message-ID: <20130102183351.GA28554@kroah.com>
References: <1357134877-27141-1-git-send-email-dreisner@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357134877-27141-1-git-send-email-dreisner@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 08:54:37AM -0500, Dave Reisner wrote:
> This patch technically breaks userspace, but I suspect that anyone who
> actually used this flag would have encountered this brokenness, declared
> it lunacy, and already sent a patch.

Kees is the one that originally did this change (I think, right?)

Kees, any objection to this patch?  Will it break your existing systems?

thanks,

greg k-h

> 
> Signed-off-by: Dave Reisner <dreisner@archlinux.org>
> ---
>  fs/debugfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index 153bb1e..a5f12b7 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -176,7 +176,7 @@ static int debugfs_parse_options(char *data, struct debugfs_mount_opts *opts)
>  			opts->uid = uid;
>  			break;
>  		case Opt_gid:
> -			if (match_octal(&args[0], &option))
> +			if (match_int(&args[0], &option))
>  				return -EINVAL;
>  			gid = make_kgid(current_user_ns(), option);
>  			if (!gid_valid(gid))
> -- 
> 1.8.0.3
