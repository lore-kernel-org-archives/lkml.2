Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0CaH6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:58:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:50068 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139Ab0CaH6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:58:40 -0400
Date: Wed, 31 Mar 2010 16:58:35 +0900 (JST)
Message-Id: <20100331.165835.212698315.ryusuke@osrg.net>
To: lihong.hi@gmail.com
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nilfs2: fix a wrong type conversion in nilfs_ioctl()
From: Ryusuke Konishi <konishi.ryusukelab.ntt.co.jp@osrg.net>
In-Reply-To: <20100331074100.GA11787@xhl>
References: <20100331074100.GA11787@xhl>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 31 Mar 2010 16:58:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 15:41:00 +0800, Li Hong <lihong.hi@gmail.com> wrote:
> (void * __user *) should be (void __user *)
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>

Applied.  Thank you.

Ryusuke Konishi

> ---
>  fs/nilfs2/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 313d0a2..c446017 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -648,7 +648,7 @@ static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
>  long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct inode *inode = filp->f_dentry->d_inode;
> -	void __user *argp = (void * __user *)arg;
> +	void __user *argp = (void __user *)arg;
>  
>  	switch (cmd) {
>  	case NILFS_IOCTL_CHANGE_CPMODE:
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
