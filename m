Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2DZVSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:18:08 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:40251 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab2DZVSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:18:06 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Emil Goode <emilgoode@gmail.com>
Subject: Re: [PATCH] GFS2: Return -ENOMEM only if kmalloc fails
Date: Thu, 26 Apr 2012 23:14:02 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: swhiteho@redhat.com, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1335474778-6252-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1335474778-6252-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204262314.02683.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 26. April 2012, 23:12:58 schrieb Emil Goode:
> The error variable should be assigned the value of -ENOMEM
> after the NULL check and not before.
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  fs/gfs2/acl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
> index 230eb0f..90f6328 100644
> --- a/fs/gfs2/acl.c
> +++ b/fs/gfs2/acl.c
> @@ -174,8 +174,8 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
>  
>  	len = posix_acl_to_xattr(acl, NULL, 0);
>  	data = kmalloc(len, GFP_NOFS);
> -	error = -ENOMEM;
>  	if (data == NULL)
> +		error = -ENOMEM;
>  		goto out;

Hint: read about the syntax of the if statement.
Secondly, consider how the compiler can optimize the original.

	Regards
		Oliver
