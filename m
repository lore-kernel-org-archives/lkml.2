Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0JTW2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:28:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:53928 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab0JTW2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:28:53 -0400
Date: Thu, 21 Oct 2010 09:28:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (security-testing tree related)
In-Reply-To: <20101020161024.af794b4a.sfr@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.1010210928270.8572@tundra.namei.org>
References: <20101020161024.af794b4a.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010, Stephen Rothwell wrote:

> Hi James,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> security/selinux/ss/services.c: In function 'security_read_policy':
> security/selinux/ss/services.c:3172: error: implicit declaration of function 'vmalloc_user'
> security/selinux/ss/services.c:3172: warning: assignment makes pointer from integer without a cast
> 
> Caused by commit ed167abda544bb7f8cf09dc3d3608c79e1cfb25f ("SELinux:
> allow userspace to read policy back out of the kernel") and
> bb17427490e1e295f3c0550c308684bd952a585d ("selinux: implement mmap
> on /selinux/policy").
> 
> Please see Rule 1 (in Documentation/SubmitChecklist).
> 
> I applied the following patch for today:

Thanks, applied.

> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 20 Oct 2010 16:08:00 +1100
> Subject: [PATCH] selinux: include vmalloc.h for vmalloc_user
> 
> ---
>  security/selinux/ss/services.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index 3a1739b..223c1ff 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -51,6 +51,7 @@
>  #include <linux/mutex.h>
>  #include <linux/selinux.h>
>  #include <linux/flex_array.h>
> +#include <linux/vmalloc.h>
>  #include <net/netlabel.h>
>  
>  #include "flask.h"
> -- 
> 1.7.1
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> 

-- 
James Morris
<jmorris@namei.org>
