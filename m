Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1JLPtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:49:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61348 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1JLPtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:49:09 -0400
MIME-Version: 1.0
In-Reply-To: <1318421644.2336.10.camel@x61.thuisdomein>
References: <1318421644.2336.10.camel@x61.thuisdomein>
Date: Wed, 12 Oct 2011 10:49:08 -0500
Message-ID: <CAH2r5mt2ntBmSQtmEP48ZFb4A+a_nEpP6NKgu-wOYdahPvP2Cg@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] cifs: Fix typo 'CIFS_NFSD_EXPORT'
From: Steve French <smfrench@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, Steve French <sfrench@samba.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged into cifs git tree.

On Wed, Oct 12, 2011 at 7:14 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> It should be 'CONFIG_CIFS_NFSD_EXPORT'. No-one noticed because that
> symbol depends on BROKEN.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> It is once again clear what was intended. But perhaps maintainer
> approval is still needed. (I've only eyeball-tested this.)
>
>  fs/cifs/cifsfs.c |    4 ++--
>  fs/cifs/cifsfs.h |    4 ++--
>  fs/cifs/export.c |    4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 54b8f1e..5dd83ef 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -132,12 +132,12 @@ cifs_read_super(struct super_block *sb)
>        else
>                sb->s_d_op = &cifs_dentry_ops;
>
> -#ifdef CIFS_NFSD_EXPORT
> +#ifdef CONFIG_CIFS_NFSD_EXPORT
>        if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
>                cFYI(1, "export ops supported");
>                sb->s_export_op = &cifs_export_ops;
>        }
> -#endif /* CIFS_NFSD_EXPORT */
> +#endif /* CONFIG_CIFS_NFSD_EXPORT */
>
>        return 0;
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 95da802..d9dbaf8 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -121,9 +121,9 @@ extern ssize_t      cifs_getxattr(struct dentry *, const char *, void *, size_t);
>  extern ssize_t cifs_listxattr(struct dentry *, char *, size_t);
>  extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
>
> -#ifdef CIFS_NFSD_EXPORT
> +#ifdef CONFIG_CIFS_NFSD_EXPORT
>  extern const struct export_operations cifs_export_ops;
> -#endif /* CIFS_NFSD_EXPORT */
> +#endif /* CONFIG_CIFS_NFSD_EXPORT */
>
>  #define CIFS_VERSION   "1.75"
>  #endif                         /* _CIFSFS_H */
> diff --git a/fs/cifs/export.c b/fs/cifs/export.c
> index 55d87ac..9c7ecdc 100644
> --- a/fs/cifs/export.c
> +++ b/fs/cifs/export.c
> @@ -45,7 +45,7 @@
>  #include "cifs_debug.h"
>  #include "cifsfs.h"
>
> -#ifdef CIFS_NFSD_EXPORT
> +#ifdef CONFIG_CIFS_NFSD_EXPORT
>  static struct dentry *cifs_get_parent(struct dentry *dentry)
>  {
>        /* BB need to add code here eventually to enable export via NFSD */
> @@ -63,5 +63,5 @@ const struct export_operations cifs_export_ops = {
>        .encode_fs =  */
>  };
>
> -#endif /* CIFS_NFSD_EXPORT */
> +#endif /* CONFIG_CIFS_NFSD_EXPORT */
>
> --
> 1.7.4.4
>
>
>
>



-- 
Thanks,

Steve
