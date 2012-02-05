Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2BELWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:22:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab2BELWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:22:11 -0500
Date: Sun, 5 Feb 2012 06:22:04 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: Re: [PATCH] CIFS: Fix NULL pointer dereference in
 cifs_construct_tcon()
Message-ID: <20120205062204.763bdab6@tlielax.poochiereds.net>
In-Reply-To: <alpine.LNX.2.00.1202050030520.30244@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202050030520.30244@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Feb 2012 00:35:19 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> If the call to kcalloc() fails and returns NULL we'll dereference a
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

Thanks. Dan Carpenter already sent a patch a couple of weeks ago to fix
this. Steve has it in his tree, but hasn't pushed it to Linus yet.

Steve, is there a reason you're waiting?

-- 
Jeff Layton <jlayton@redhat.com>
