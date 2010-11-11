Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab0KKCi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 21:38:27 -0500
Received: from sh.osrg.net ([192.16.179.4]:53460 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab0KKCi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 21:38:26 -0500
Date: Thu, 11 Nov 2010 11:38:20 +0900 (JST)
Message-Id: <20101111.113820.179935215.ryusuke@osrg.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp,
        linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 7/9] fs/nilfs2/super.c: Use printf extension %pV
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1addeb606bca88e09fb46b93be10c3a58e759348.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
	<1addeb606bca88e09fb46b93be10c3a58e759348.1289348757.git.joe@perches.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 11 Nov 2010 11:38:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Nov 2010 16:35:21 -0800, Joe Perches wrote:
> Using %pV reduces the number of printk calls and
> eliminates any possible message interleaving from
> other printk calls.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/nilfs2/super.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)

Applied to the nilfs tree.

Thank you.

Ryusuke Konishi
 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index f804d41..bef8cc6 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -111,12 +111,17 @@ void nilfs_error(struct super_block *sb, const char *function,
>  		 const char *fmt, ...)
>  {
>  	struct nilfs_sb_info *sbi = NILFS_SB(sb);
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	printk(KERN_CRIT "NILFS error (device %s): %s: ", sb->s_id, function);
> -	vprintk(fmt, args);
> -	printk("\n");
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	printk(KERN_CRIT "NILFS error (device %s): %s: %pV\n",
> +	       sb->s_id, function, &vaf);
> +
>  	va_end(args);
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
> @@ -136,13 +141,17 @@ void nilfs_error(struct super_block *sb, const char *function,
>  void nilfs_warning(struct super_block *sb, const char *function,
>  		   const char *fmt, ...)
>  {
> +	struct va_format vaf;
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	printk(KERN_WARNING "NILFS warning (device %s): %s: ",
> -	       sb->s_id, function);
> -	vprintk(fmt, args);
> -	printk("\n");
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	printk(KERN_WARNING "NILFS warning (device %s): %s: %pV\n",
> +	       sb->s_id, function, &vaf);
> +
>  	va_end(args);
>  }
>  
> -- 
> 1.7.3.1.g432b3.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
