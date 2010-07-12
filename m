Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab0GLFcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 01:32:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:55158 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab0GLFb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 01:31:59 -0400
Date: Mon, 12 Jul 2010 14:31:49 +0900 (JST)
Message-Id: <20100712.143149.252511321.ryusuke@osrg.net>
To: sfr@canb.auug.org.au, viro@ZenIV.linux.org.uk
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        konishi.ryusuke@lab.ntt.co.jp
Subject: Re: linux-next: build failure after merge of the vfs tree
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20100712122458.3fe5c01a.sfr@canb.auug.org.au>
References: <20100712122458.3fe5c01a.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 12 Jul 2010 14:31:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 12:24:58 +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nilfs2/inode.c: In function 'nilfs_clear_inode':
> fs/nilfs2/inode.c:630: error: implicit declaration of function 'nilfs_btnode_cache_clear'
> 
> Caused by commit 743a0a2f1a89e53d656ec6a2f715111d92642bcb ("convert
> nilfs2 to ->evict_inode()") interacting with commit
> ceb4f9c819c321e7eabf53b51f956ff959561573 ("nilfs2: get rid of
> nilfs_bmap_union") from the nilfs2 tree which removed the implicit
> inclusion of btnode.h (via bmap_union.h via nilfs.h).
> 
> I have added the following patch for today (which should be applied to
> the vfs tree or merged into the above vfs tree commit):

Thank you for the catch.

I would appreciate it if this is applied to the vfs tree.

The problem is that I didn't include btnode.h in nilfs2/super.c, but
the above handling looks natural since the current nilfs2/inode.c does
not need the inclusion of btnode.h.

Regards,
Ryusuke Konishi

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 12 Jul 2010 12:17:47 +1000
> Subject: [PATCH] nilfs2: inode.c needs to include btnode.h directly now
> 
> Due to the new usage of nilfs_btnode_cache_clear().
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/nilfs2/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
> index 8fea40e..eccb2f2 100644
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -27,6 +27,7 @@
>  #include <linux/writeback.h>
>  #include <linux/uio.h>
>  #include "nilfs.h"
> +#include "btnode.h"
>  #include "segment.h"
>  #include "page.h"
>  #include "mdt.h"
> -- 
> 1.7.1
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
