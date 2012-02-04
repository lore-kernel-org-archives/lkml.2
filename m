Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2BDXhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 18:37:20 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10318 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2BDXhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 18:37:18 -0500
Date: Sun, 5 Feb 2012 00:37:45 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-cifs@vger.kernel.org
cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Steve French <sfrench@samba.org>
Subject: Re: [PATCH] CIFS: Fix NULL pointer dereference in
 cifs_construct_tcon()
In-Reply-To: <alpine.LNX.2.00.1202050030520.30244@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1202050037300.30244@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202050030520.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Feb 2012, Jesper Juhl wrote:

> If the call to kcalloc() fails and returns NULL we'll dereference a

s/kcalloc/kzalloc/

> NULL 'vol_info' after we jump to the 'out:' label.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  fs/cifs/connect.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 986709a..bd67b7c 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3859,7 +3859,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
>  	vol_info = kzalloc(sizeof(*vol_info), GFP_KERNEL);
>  	if (vol_info == NULL) {
>  		tcon = ERR_PTR(-ENOMEM);
> -		goto out;
> +		goto out2;
>  	}
>  
>  	vol_info->local_nls = cifs_sb->local_nls;
> @@ -3901,7 +3901,7 @@ out:
>  	kfree(vol_info->username);
>  	kfree(vol_info->password);
>  	kfree(vol_info);
> -
> +out2:
>  	return tcon;
>  }
>  
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

