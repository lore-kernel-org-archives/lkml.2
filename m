Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1GaFox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:44:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:47114 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1GaFor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:44:47 -0400
Date: Sun, 31 Jul 2011 01:44:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110731054442.GD31842@windriver.com>
References: <20110729145644.ce9b20c535822ede35cd0a0c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729145644.ce9b20c535822ede35cd0a0c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 14:56) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> arch/powerpc/platforms/cell/spu_syscalls.c: In function 'spufs_calls_get':
> arch/powerpc/platforms/cell/spu_syscalls.c:42:2: error: implicit declaration of function 'try_module_get'
> arch/powerpc/platforms/cell/spu_syscalls.c: In function 'spufs_calls_put':
> arch/powerpc/platforms/cell/spu_syscalls.c:54:2: error: implicit declaration of function 'module_put'
> 
> Caused by commit f7f927183dba ("powerpc: various straight conversions
> from module.h --> export.h").  This file should not be modified.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 14:53:16 +1000
> Subject: [PATCH] Partial revert of f7f927183dba

Thanks, I've dropped the offending hunk from its origin.

Paul.

> 
> "powerpc: various straight conversions from module.h --> export.h"
> 
> This file needs module.h.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/powerpc/platforms/cell/spu_syscalls.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
> index 60fc5ec..75530d9 100644
> --- a/arch/powerpc/platforms/cell/spu_syscalls.c
> +++ b/arch/powerpc/platforms/cell/spu_syscalls.c
> @@ -22,7 +22,7 @@
>   */
>  #include <linux/file.h>
>  #include <linux/fs.h>
> -#include <linux/export.h>
> +#include <linux/module.h>
>  #include <linux/syscalls.h>
>  #include <linux/rcupdate.h>
>  
> -- 
> 1.7.5.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
