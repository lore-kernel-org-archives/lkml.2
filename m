Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0DGO3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:29:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34868 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab0DGO3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=xRZIdmAWbP2ICeTwSZgbYLq01KV0XnLSAhBm/c8wIaa9P0OzHKckOGnNEY23iFloVt
         GNWYvAqhhZnmaxcHaSeetb8udeaLxFgN+7aY8TnDUzIeatsqJmeptQzTG2Tw3QoijRWz
         AseBIzQ7qarIJpTk0SH2cESILjde+bNjLq7Sk=
Date: Wed, 7 Apr 2010 22:20:58 +0800
From: Li Hong <lihong.hi@gmail.com>
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
       linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
Message-ID: <20100407142058.GA27224@xhl>
Mail-Followup-To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100405173402.GA22644@xhl>
 <20100405173534.GB22644@xhl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405173534.GB22644@xhl>
X-Operating-System: Linux xhl 2.6.31-14-generic
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KONISHI Ryusuke,

Any feedbacks on these patches?

Thanks,
Li Hong
On Tue, Apr 06, 2010 at 01:35:34AM +0800, Li Hong wrote:
> From b4e426f77cd05bd6046c1fa67c51ee06368ea23e Mon Sep 17 00:00:00 2001
> From: Li Hong <lihong.hi@gmail.com>
> Date: Tue, 6 Apr 2010 01:23:04 +0800
> Subject: [PATCH] nilfs2: add a print message after loading nilfs2
> 
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> ---
>  fs/nilfs2/super.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 2e767bc..9f91765 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -1186,7 +1186,12 @@ static int __init init_nilfs_fs(void)
>  		return err;
>  
>  	err = register_filesystem(&nilfs_fs_type);
> -	return err;
> +	if (err)
> +		return err;
> +
> +	printk(KERN_INFO "nilfs2 file system loaded!\n");
> +	return 0;
> +
>  }
>  
>  static void __exit exit_nilfs_fs(void)
> -- 
> 1.6.3.3
> 
