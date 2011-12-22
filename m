Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1LVGQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 01:16:41 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47879 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1LVGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 01:16:38 -0500
Message-ID: <1324534592.2621.37.camel@edumazet-laptop>
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Date: Thu, 22 Dec 2011 07:16:32 +0100
In-Reply-To: <20111222170726.b16565ef7d1434cc4ec170d7@canb.auug.org.au>
References: <20111222170726.b16565ef7d1434cc4ec170d7@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 22 décembre 2011 à 17:07 +1100, Stephen Rothwell a écrit :
> Hi all,
> 
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
> 
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

Thanks Stephen

I did a revert of a previous patch, and at that time prefetch() was
probably included in some header.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


