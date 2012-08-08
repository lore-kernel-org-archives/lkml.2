Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab2HHNeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:34:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61459 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211Ab2HHNee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:34:34 -0400
Date: Wed, 8 Aug 2012 06:34:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: iommu@lists.linux-foundation.org, linux-tegra@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] debugfs: Allow debugfs_create_dir() to take data
Message-ID: <20120808133427.GA14417@kroah.com>
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
 <1344407073-12030-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344407073-12030-2-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 09:24:32AM +0300, Hiroshi Doyu wrote:
> Add __debugfs_create_dir(), which takes data passed from caller.

Why?

> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  fs/debugfs/inode.c      |    7 ++++---
>  include/linux/debugfs.h |    9 ++++++++-
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index 4733eab..423df9f 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -387,7 +387,7 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
>  EXPORT_SYMBOL_GPL(debugfs_create_file);
>  
>  /**
> - * debugfs_create_dir - create a directory in the debugfs filesystem
> + * __debugfs_create_dir - create a directory in the debugfs filesystem
>   * @name: a pointer to a string containing the name of the directory to
>   *        create.
>   * @parent: a pointer to the parent dentry for this file.  This should be a
> @@ -404,10 +404,11 @@ EXPORT_SYMBOL_GPL(debugfs_create_file);
>   * If debugfs is not enabled in the kernel, the value -%ENODEV will be
>   * returned.
>   */
> -struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
> +struct dentry *__debugfs_create_dir(const char *name, struct dentry *parent,
> +				    void *data)
>  {
>  	return __create_file(name, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
> -				   parent, NULL, NULL);
> +				   parent, data, NULL);
>  }
>  EXPORT_SYMBOL_GPL(debugfs_create_dir);

You can't export a symbol that doesn't exist anymore.

What are you trying to do here?  This patch doesn't look right at all.

greg k-h
