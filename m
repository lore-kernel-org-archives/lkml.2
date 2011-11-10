Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966144Ab1KJDvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:51:42 -0500
Received: from sh.osrg.net ([192.16.179.4]:58350 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936124Ab1KJDta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:30 -0500
Date: Thu, 10 Nov 2011 12:49:18 +0900 (JST)
Message-Id: <20111110.124918.255392182.ryusuke@osrg.net>
To: thomas@m3y3r.de
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH] nilfs2: unbreak compat ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1320697117.1396.4.camel@localhost.localdomain>
References: <1320697117.1396.4.camel@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 10 Nov 2011 12:49:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Nov 2011 21:18:37 +0100, Thomas Meyer wrote:
> I guess commit 828b1c50ae11e6dda68f8dfefe43b74c7182b157 incidentally broke
> all other compat ioctls. make them work again.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>  fs/nilfs2/ioctl.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 41d6743..1773a98 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -842,8 +842,6 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case FS_IOC32_GETVERSION:
>  		cmd = FS_IOC_GETVERSION;
>  		break;
> -	default:
> -		return -ENOIOCTLCMD;
>  	}
>  	return nilfs_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
>  }
> -- 
> 1.7.7

Hi, thank you for pointing this out.

But, this patch looks to prevent compat_sys_ioctl() from handling
other compatible ioctls that compat_ioctl_check_table function
detects.  For instance, fiemap (FS_IOC_FIEMAP) is handled via the
function.

I think we should only redirect own ioctl commands
(i.e. NILFS_IOCTL_xxxx) to the nilfs_ioctl() call.


Regards,
Ryusuke Konishi
