Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1GaIYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 04:24:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:62294 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1GaIYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 04:24:15 -0400
Date: Sun, 31 Jul 2011 04:24:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, <linux-raid@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the moduleh tree
Message-ID: <20110731082405.GM31842@windriver.com>
References: <20110729152548.17e093cb01d95077a05d4cec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729152548.17e093cb01d95077a05d4cec@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build warnings after merge of the moduleh tree] On 29/07/2011 (Fri 15:25) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> drivers/md/persistent-data/dm-block-manager.c:103:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
[...]
> drivers/md/persistent-data/dm-space-map-disk.c:634:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
[...]
> drivers/md/persistent-data/dm-btree.c:146:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
[...]
> drivers/md/persistent-data/dm-btree-remove.c:569:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> 
> I have added the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 15:16:04 +1000
> Subject: [PATCH] include export.h to use EXPORT_SYMBOL
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/md/persistent-data/dm-block-manager.c  |    1 +
>  drivers/md/persistent-data/dm-btree-remove.c   |    2 ++
>  drivers/md/persistent-data/dm-btree.c          |    1 +
>  drivers/md/persistent-data/dm-space-map-disk.c |    1 +
>  4 files changed, 5 insertions(+), 0 deletions(-)

This one is a bit more interesting.  The above files (and actually their
parent dir) doesn't exist yet in master/HEAD.  So I can't patch them
yet.  And the MD maintainers can't patch in export.h usage, since they
won't have such a header file.

If you didn't want to temporarily carry it, I can think of two things:
I suppose, since the one single commit that creates export.h is totally
standalone, and harmless/inert in itself, we could perhaps get it pulled
independently if it made life easier for others to align to the right
usage?  Or they can just patch in module.h usage and we can downgrade
them to export.h usage shortly thereafter.

Paul.

> 
> diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
> index 4ec480c..7b8e84c 100644
> --- a/drivers/md/persistent-data/dm-block-manager.c
> +++ b/drivers/md/persistent-data/dm-block-manager.c
> @@ -9,6 +9,7 @@
>  #include <linux/dm-io.h>
>  #include <linux/slab.h>
>  #include <linux/device-mapper.h>
> +#include <linux/export.h>
>  
>  #define DM_MSG_PREFIX "block manager"
>  
> diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
> index 72c9705..e7071f6 100644
> --- a/drivers/md/persistent-data/dm-btree-remove.c
> +++ b/drivers/md/persistent-data/dm-btree-remove.c
> @@ -8,6 +8,8 @@
>  #include "dm-btree-internal.h"
>  #include "dm-transaction-manager.h"
>  
> +#include <linux/export.h>
> +
>  /*
>   * Removing an entry from a btree
>   * ==============================
> diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
> index 55b8bf3..7cad5e8 100644
> --- a/drivers/md/persistent-data/dm-btree.c
> +++ b/drivers/md/persistent-data/dm-btree.c
> @@ -9,6 +9,7 @@
>  #include "dm-transaction-manager.h"
>  
>  #include <linux/device-mapper.h>
> +#include <linux/export.h>
>  
>  #define DM_MSG_PREFIX "btree"
>  
> diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
> index de31096..26e6e19 100644
> --- a/drivers/md/persistent-data/dm-space-map-disk.c
> +++ b/drivers/md/persistent-data/dm-space-map-disk.c
> @@ -13,6 +13,7 @@
>  #include <linux/slab.h>
>  #include <linux/bitops.h>
>  #include <linux/device-mapper.h>
> +#include <linux/export.h>
>  
>  #define DM_MSG_PREFIX "space map disk"
>  
> -- 
> 1.7.5.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
