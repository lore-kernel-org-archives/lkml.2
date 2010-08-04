Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab0HDOvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:51:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40848 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0HDOvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:51:37 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, miklos@szeredi.hu, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vaurora@redhat.com
In-reply-to: <1276627208-17242-20-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Tue, 15 Jun 2010 11:39:49 -0700)
Subject: Re: [PATCH 19/38] union-mount: Introduce union_dir structure and basic operations
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-20-git-send-email-vaurora@redhat.com>
Message-Id: <E1OgfJb-0000n9-KZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Aug 2010 16:51:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010, Valerie Aurora wrote:
> This patch adds the basic structures and operations of VFS-based union
> mounts (but not the ability to mount or lookup unioned file systems).
> Each directory in a unioned file system has an associated union stack
> created when the directory is first looked up.  The union stack is a
> union_dir structure kept in a hash table indexed by mount and dentry
> of the directory; thus, specific paths are unioned, not dentries
> alone.  The union_dir keeps a pointer to the upper path and the lower
> path and can be looked up by either path.  Currently only two layers
> are supported, but the union_dir struct is flexible enough to allow
> more than two layers.
> 
> This particular version of union mounts is based on ideas by Jan
> Blunck, Bharata Rao, and many others.
> 
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---


> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -100,7 +100,9 @@ struct dentry {
>  	struct hlist_node d_hash;	/* lookup hash list */
>  	struct dentry *d_parent;	/* parent directory */
>  	struct qstr d_name;
> -
> +#ifdef CONFIG_UNION_MOUNT
> +	struct union_dir *d_union_dir;	/* head of union stack */
> +#endif

This botches the carefully tuned length of struct dentry.  At least a
FIXME comment needs to be added that this is something to be
addressed.

Why was the hash table concept dropped?  The header comment still
talks about that?

Miklos
