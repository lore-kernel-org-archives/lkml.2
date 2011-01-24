Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1AXEbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:31:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63880 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1AXEbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N4EVrQqrZAqh9v/Z3e4HVBK3135BAh7ux9XKfysAA5GoVtX7Hloa6uDZ20lMl5grP+
         bpsRYuRZiKvTxzHvSLoX1tn7QaOAgqbwOGaKgGTe+c0IOdSOVwImvNP4K9BsF4aNSpW/
         E2IvHYybbJn6Pa8fVxzV4trlEE0amxn1dTzEU=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101222101070.7746@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101222101070.7746@swampdragon.chaosbits.net>
Date: Sun, 23 Jan 2011 22:31:08 -0600
Message-ID: <AANLkTinjC74qUzuTc7xjgD7uvMN7q2tqkJt_SOqNO73-@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Remove pointless variable assignment in cifs_dfs_do_automount()
From: Steve French <smfrench@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged - thx

On Sat, Jan 22, 2011 at 2:07 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> In fs/cifs/cifs_dfs_ref.c::cifs_dfs_do_automount() we have this code:
>
>        ...
>        mnt = ERR_PTR(-EINVAL);
>        if (IS_ERR(tlink)) {
>                mnt = ERR_CAST(tlink);
>                goto free_full_path;
>        }
>        ses = tlink_tcon(tlink)->ses;
>
>        rc = get_dfs_path(xid, ses, full_path + 1, cifs_sb->local_nls,
>                &num_referrals, &referrals,
>                cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
>
>        cifs_put_tlink(tlink);
>
>        mnt = ERR_PTR(-ENOENT);
>        ...
>
> The assignment of 'mnt = ERR_PTR(-EINVAL);' is completely pointless. If we
> take the 'if (IS_ERR(tlink))' branch we'll set 'mnt' again and we'll also
> do so if we do not take the branch. There is no way we'll ever use 'mnt'
> with the assigned 'ERR_PTR(-EINVAL)' value, so we may as well just remove
> the pointless assignment.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  cifs_dfs_ref.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index 7ed3653..f1c6862 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -297,7 +297,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
>
>        cifs_sb = CIFS_SB(mntpt->d_inode->i_sb);
>        tlink = cifs_sb_tlink(cifs_sb);
> -       mnt = ERR_PTR(-EINVAL);
>        if (IS_ERR(tlink)) {
>                mnt = ERR_CAST(tlink);
>                goto free_full_path;
>
>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks,

Steve
