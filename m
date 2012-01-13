Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2AMMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:25:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62685 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2AMMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:25:55 -0500
Date: Fri, 13 Jan 2012 10:25:47 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sorin Dumitru <dumitru.sorin87@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] perf: check if address is in range
Message-ID: <20120113122547.GA8161@infradead.org>
References: <1326400778-24131-1-git-send-email-dumitru.sorin87@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326400778-24131-1-git-send-email-dumitru.sorin87@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 12, 2012 at 10:39:38PM +0200, Sorin Dumitru escreveu:
> When addr isn't in the [sym->start,sym->end] range offset
> will be a very big value, giving us a segfault when we do:
> 	h->addr[offset]++
> Fix this by checking that addr is in the correct range.

Is this against what tree? Can you please provide a backtrace of when
this happens?

I ask this because this is a kind of BUG_ON() situation, one shouldn't
get to this point if the address is not within that symbol.

- Arnaldo
 
> Signed-off-by: Sorin Dumitru <dumitru.sorin87@gmail.com>
> ---
>  tools/perf/util/annotate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 011ed26..4ddc55f 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
>  
>  	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
>  
> -	if (addr >= sym->end)
> +	if (addr <= sym->start || addr >= sym->end)
>  		return 0;
>  
>  	offset = addr - sym->start;
> -- 
> 1.7.8.3
