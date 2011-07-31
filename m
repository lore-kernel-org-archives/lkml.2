Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1GaH0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:26:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:56741 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1GaH0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 03:26:30 -0400
Date: Sun, 31 Jul 2011 03:26:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110731072625.GG31842@windriver.com>
References: <20110729162418.b3154ff2b25de69a55c22329@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729162418.b3154ff2b25de69a55c22329@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 16:24) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> kernel/ksysfs.c:161:11: error: 'S_IRUGO' undeclared here (not in a function)

I had a similar commit to this in tree already:

http://git.kernel.org/?p=linux/kernel/git/paulg/linux.git;a=commit;h=f82a90450b1cb580f3b7e8da7d8f41380b49145c

I must have added it after you had pulled your copy.
In any case, we shoudn't see this one again.

Thanks,
Paul.

> 
> Caused by commit d03b684f1773 ("kernel: Map most files to use export.h
> instead of module.h").
> 
> I added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 16:21:37 +1000
> Subject: [PATCH] ksysfs: include stat.h for S_IRUGO
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  kernel/ksysfs.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index 6771de3..ece4547 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -17,6 +17,7 @@
>  #include <linux/profile.h>
>  #include <linux/sched.h>
>  #include <linux/capability.h>
> +#include <linux/stat.h>
>  
>  #define KERNEL_ATTR_RO(_name) \
>  static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
> -- 
> 1.7.5.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
