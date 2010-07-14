Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab0GNC2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:28:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41880 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0GNC2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:28:51 -0400
X-Authority-Analysis: v=1.1 cv=eWk9bc5BAcy1KEyGm/gc5mmqTM7Cp/ADlcqpp9MTMWU= c=1 sm=0 a=mdEjYFg04ucA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=cchYIZNtPBSgI_3n9yoA:9 a=apPpIAG8ZX_o_R3WjGkA:7 a=8i3-RsGoWqOFg4qIPRFFv8ZXt0wA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=lBRciGGoxdUA:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Tue, 13 Jul 2010 21:30:48 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Yama: verify inode is symlink to avoid bind mounts
Message-ID: <20100714023048.GB17686@hallyn.com>
References: <20100713223021.GK6104@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713223021.GK6104@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> The inode_follow_link LSM hook is called in bind mount situations as
> well as for symlink situations, so we must explicitly check for the
> inode being a symlink to not reject bind mounts in 1777 directories,

Are you sure about that??

If that's true, you might also expand the comment in
include/linux/security.h.

> which seems to be a common NFSv4 configuration.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  security/yama/yama_lsm.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index 3b76386..c70eb10 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -116,6 +116,10 @@ static int yama_inode_follow_link(struct dentry *dentry,
>  	if (!protected_sticky_symlinks)
>  		return 0;
>  
> +	/* if inode isn't a symlink, don't try to evaluate blocking it */
> +	if (!S_ISLNK(inode->i_mode))
> +		return 0;
> +
>  	/* owner and follower match? */
>  	cred = current_cred();
>  	inode = dentry->d_inode;
> -- 
> 1.7.1
> 
> 
> -- 
> Kees Cook
> Ubuntu Security Team
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
