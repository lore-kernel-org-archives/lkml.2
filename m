Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0KXXcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:32:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab0KXXcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:32:31 -0500
Date: Wed, 24 Nov 2010 15:31:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: benh@kernel.crashing.org, yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memblock: fix memblock_is_region_memory()
Message-Id: <20101124153154.a0e68722.akpm@linux-foundation.org>
In-Reply-To: <1289214013-13449-1-git-send-email-tomi.valkeinen@nokia.com>
References: <1289214013-13449-1-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Nov 2010 13:00:13 +0200
Tomi Valkeinen <tomi.valkeinen@nokia.com> wrote:

> To: benh@kernel.crashing.org, yinghai@kernel.org

wakey wakey!

> memblock_is_region_memory() uses reserved memblocks to search for the
> given region, while it should use the memory memblocks.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
> ---
>  mm/memblock.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 400dc62..bdba245 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -683,13 +683,13 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
>  
>  int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
>  {
> -	int idx = memblock_search(&memblock.reserved, base);
> +	int idx = memblock_search(&memblock.memory, base);
>  
>  	if (idx == -1)
>  		return 0;
> -	return memblock.reserved.regions[idx].base <= base &&
> -		(memblock.reserved.regions[idx].base +
> -		 memblock.reserved.regions[idx].size) >= (base + size);
> +	return memblock.memory.regions[idx].base <= base &&
> +		(memblock.memory.regions[idx].base +
> +		 memblock.memory.regions[idx].size) >= (base + size);
>  }

What were the runtime effects of this problem?

afacit the only callers are a couple of obscure fbdev drivers.  Do you
know of other callers?

Thanks.

