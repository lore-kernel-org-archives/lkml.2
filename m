Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0LABgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:36:08 -0500
Received: from kroah.org ([198.145.64.141]:53376 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab0LABgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:36:06 -0500
Date: Tue, 30 Nov 2010 17:35:47 -0800
From: Greg KH <greg@kroah.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Patch] debugfs: remove module_exit()
Message-ID: <20101201013547.GA19390@kroah.com>
References: <20101109092449.6284.90481.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109092449.6284.90481.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 04:19:58AM -0500, Amerigo Wang wrote:
> debugfs can't be a module, so module_exit() is meaningless
> for it.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index 37a8ca7..d38c88f 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -13,9 +13,6 @@
>   *
>   */
>  
> -/* uncomment to get debug messages from the debug filesystem, ah the irony. */
> -/* #define DEBUG */

Why did you remove these lines?  They don't pertain to this patch.

> -
>  #include <linux/module.h>
>  #include <linux/fs.h>
>  #include <linux/mount.h>
> @@ -540,17 +537,5 @@ static int __init debugfs_init(void)
>  
>  	return retval;
>  }
> -
> -static void __exit debugfs_exit(void)
> -{
> -	debugfs_registered = false;
> -
> -	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
> -	unregister_filesystem(&debug_fs_type);
> -	kobject_put(debug_kobj);
> -}

When the code is built into the kernel, the __exit function should go
away, so this isn't costing us any extra memory, right?

And debugfs used to be able to be built as a module, perhaps it will be
in the future?  I don't think this patch is really needed.

thanks,

greg k-h
