Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0G1F2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:28:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:52179 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0G1F15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:27:57 -0400
Subject: Re: [PATCH 29/31] memblock: Prepare to include linux/memblock.h in
 core file
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1279822864-17154-30-git-send-email-yinghai@kernel.org>
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
	 <1279822864-17154-30-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 15:27:31 +1000
Message-ID: <1280294851.1970.242.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:21 -0700, Yinghai Lu wrote:
> Need to add protection in linux/memblock.h, to prepare to include it in
>  mm/page_alloc.c and mm/bootmem.c etc.

Not really no ... having the definitions shouldn't hurt whether memblock
is used or not, no ?

I'm going to keep that patch in the queue because it has one advantage
that you don't mention, which is to more easily catch attempts to
use those functions when CONFIG_HAVE_MEMBLOCK isn't set, but I'll update
the commit message.

Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  include/linux/memblock.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 89749c4..4aaaf0d 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_MEMBLOCK_H
>  #ifdef __KERNEL__
>  
> +#ifdef CONFIG_HAVE_MEMBLOCK
>  /*
>   * Logical memory blocks.
>   *
> @@ -147,6 +148,8 @@ static inline unsigned long memblock_region_pages(const struct memblock_region *
>  	     region++)
>  
> 
> +#endif /* CONFIG_HAVE_MEMBLOCK */
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* _LINUX_MEMBLOCK_H */


