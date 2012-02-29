Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030715Ab2B2G6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:58:51 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34324 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2B2G6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:58:49 -0500
Date: Wed, 29 Feb 2012 14:58:08 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/73] VFS: Add CL_NO_SLAVE flag to
 clone_mnt()/copy_tree() [ver #2]
Message-ID: <20120229065808.GC5030@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
 <20120221175832.25235.96909.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221175832.25235.96909.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022906-7282-0000-0000-000006F2DB83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 05:58:32PM +0000, David Howells wrote:
> From: Valerie Aurora <vaurora@redhat.com>
> 
> Passing the CL_NO_SLAVE flag to clone_mnt() causes the clone
> to fail if the source mnt is a slave.
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
> index f92f574..96f43f2 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -743,6 +743,9 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
>  	if ((flag & CL_NO_SHARED) && IS_MNT_SHARED(old))
>  		return ERR_PTR(-EINVAL);
> 
> +	if ((flag & CL_NO_SLAVE) && IS_MNT_SLAVE(old))
> +		return ERR_PTR(-EINVAL);
> +
>  	mnt = alloc_vfsmnt(old->mnt_devname);
>  	if (!mnt)
>  		return ERR_PTR(-ENOMEM);
> diff --git a/fs/pnode.h b/fs/pnode.h
> index c7089dd..f7ae149 100644
> --- a/fs/pnode.h
> +++ b/fs/pnode.h
> @@ -23,6 +23,7 @@
>  #define CL_MAKE_SHARED 		0x08
>  #define CL_PRIVATE 		0x10
>  #define CL_NO_SHARED 		0x20
> +#define CL_NO_SLAVE 		0x40
> 
>  static inline void set_mnt_shared(struct mount *mnt)
>  {

