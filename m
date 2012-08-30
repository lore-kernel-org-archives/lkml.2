Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2H3X7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:59:13 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:57782 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2H3X7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:59:12 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2012 19:59:12 EDT
Date: Fri, 31 Aug 2012 01:49:37 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/8] hpfs: drop lock/unlock super
In-Reply-To: <503F7F9A.3070402@gmail.com>
Message-ID: <alpine.DEB.2.00.1208310149320.27929@artax.karlin.mff.cuni.cz>
References: <503F7F9A.3070402@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks ok.

Mikulas

On Thu, 30 Aug 2012, Marco Stornelli wrote:

> Removed lock/unlock super.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  fs/hpfs/super.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
> index 706a12c..8af2cdc 100644
> --- a/fs/hpfs/super.c
> +++ b/fs/hpfs/super.c
> @@ -389,7 +389,6 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
>  	*flags |= MS_NOATIME;
>  	
>  	hpfs_lock(s);
> -	lock_super(s);
>  	uid = sbi->sb_uid; gid = sbi->sb_gid;
>  	umask = 0777 & ~sbi->sb_mode;
>  	lowercase = sbi->sb_lowercase;
> @@ -422,12 +421,10 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
>  
>  	replace_mount_options(s, new_opts);
>  
> -	unlock_super(s);
>  	hpfs_unlock(s);
>  	return 0;
>  
>  out_err:
> -	unlock_super(s);
>  	hpfs_unlock(s);
>  	kfree(new_opts);
>  	return -EINVAL;
> -- 
> 1.7.3.4
> 
