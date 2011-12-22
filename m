Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1LVHER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:04:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59752 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1LVHEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:04:14 -0500
Date: Thu, 22 Dec 2011 02:01:59 -0500 (EST)
Message-Id: <20111222.020159.138601584172644611.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        eric.dumazet@gmail.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111222170726.b16565ef7d1434cc4ec170d7@canb.auug.org.au>
References: <20111222170726.b16565ef7d1434cc4ec170d7@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 23:02:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 22 Dec 2011 17:07:26 +1100

> After merging the final tree, today's linux-next build (sparc32 defconfig)
> failed like this:
> 
> net/ipv4/route.c: In function 'rt_check_expire':
> net/ipv4/route.c:873:4: error: implicit declaration of function 'prefetch' [-Werror=implicit-function-declaration]
> 
> Caused by commit 9f28a2fc0bd7 ("ipv4: reintroduce route cache garbage
> collector").
> 
> Linus, that commit is in the latest pull request you have from Dave ...

Sorry, that was just reinstating code that got removed but we forgot
the prefetch.h header.  Both Eric and I test built this as well as did
run time testing on the fix.

Linus, could you just apply this obvious fix directly?  Sorry for the
trouble.

Thanks.

> I applied the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 22 Dec 2011 17:03:29 +1100
> Subject: [PATCH] ipv4: using prefetch requires including prefetch.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/ipv4/route.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 7460483..9c01f56 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -91,6 +91,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/times.h>
>  #include <linux/slab.h>
> +#include <linux/prefetch.h>
>  #include <net/dst.h>
>  #include <net/net_namespace.h>
>  #include <net/protocol.h>
> -- 
> 1.7.8.197.g73c6b
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
