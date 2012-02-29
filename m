Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966088Ab2B2G40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:56:26 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56179 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab2B2G4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:56:25 -0500
Date: Wed, 29 Feb 2012 14:56:16 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/73] VFS: Add CL_NO_SHARED flag to
 clone_mnt()/copy_tree() [ver #2]
Message-ID: <20120229065616.GB5030@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
 <20120221175825.25235.96185.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221175825.25235.96185.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022906-7182-0000-0000-000000EAC68D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 05:58:25PM +0000, David Howells wrote:
> From: Valerie Aurora <vaurora@redhat.com>
> 
> Passing the CL_NO_SHARED flag to clone_mnt() causes the clone to fail
> if the source mnt is shared.
> 
> Original-author: Valerie Aurora <vaurora@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Ram Pai <linuxram@us.ibm.com>

Reviewed-by: Ram Pai <linuxram@us.ibm.com>

> ---
> 
>  fs/namespace.c |    3 +++
>  fs/pnode.h     |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 35c3b80..f92f574 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -740,6 +740,9 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
>  	struct mount *mnt;
>  	int err;
> 
> +	if ((flag & CL_NO_SHARED) && IS_MNT_SHARED(old))
> +		return ERR_PTR(-EINVAL);
> +
>  	mnt = alloc_vfsmnt(old->mnt_devname);
>  	if (!mnt)
>  		return ERR_PTR(-ENOMEM);
> diff --git a/fs/pnode.h b/fs/pnode.h
> index 65c6097..c7089dd 100644
> --- a/fs/pnode.h
> +++ b/fs/pnode.h
> @@ -22,6 +22,7 @@
>  #define CL_COPY_ALL 		0x04
>  #define CL_MAKE_SHARED 		0x08
>  #define CL_PRIVATE 		0x10
> +#define CL_NO_SHARED 		0x20
> 
>  static inline void set_mnt_shared(struct mount *mnt)
>  {

