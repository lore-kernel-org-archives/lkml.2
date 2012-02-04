Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2BDDNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 22:13:13 -0500
Received: from sh.osrg.net ([192.16.179.4]:54426 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab2BDDNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 22:13:11 -0500
Date: Sat, 04 Feb 2012 12:13:02 +0900 (JST)
Message-Id: <20120204.121302.227986518.ryusuke@osrg.net>
To: xi.wang@gmail.com, akpm@linux-foundation.org
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        haogangchen@gmail.com
Subject: Re: [PATCH] nilfs2: avoid overflowing segment numbers in
 nilfs_ioctl_clean_segments()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1328282767-13158-1-git-send-email-xi.wang@gmail.com>
References: <1328282767-13158-1-git-send-email-xi.wang@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Sat, 04 Feb 2012 12:13:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Feb 2012 10:26:07 -0500, Xi Wang wrote:
> nsegs is read from userspace.  Limit its value and avoid overflowing
> nsegs * sizeof(__u64) in the subsequent call to memdup_user().
> 
> This patch complements 481fe17e973fb97aa3edf17c69557afe88d8334f.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Cc: Haogang Chen <haogangchen@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/nilfs2/ioctl.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>


Thank you for posting this fix.

Andrew, could you send this uptream in this cycle ?

Ryusuke Konishi

> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 8866496..2a70fce 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -603,6 +603,8 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  	nsegs = argv[4].v_nmembs;
>  	if (argv[4].v_size != argsz[4])
>  		goto out;
> +	if (nsegs > UINT_MAX / sizeof(__u64))
> +		goto out;
>  
>  	/*
>  	 * argv[4] points to segment numbers this ioctl cleans.  We
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
