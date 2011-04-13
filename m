Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1DMP2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:28:15 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:48385 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757340Ab1DMP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:28:13 -0400
Date: Wed, 13 Apr 2011 17:18:51 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] genalloc: add support to specify the physical
 address
Message-ID: <20110413151851.GF4709@game.jcrosoft.org>
References: <1302192197-2248-1-git-send-email-plagnioj@jcrosoft.com>
 <1302192197-2248-2-git-send-email-plagnioj@jcrosoft.com>
 <20110412153758.c570b09a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412153758.c570b09a.akpm@linux-foundation.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13893323375880874996
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But this documentation is incorrect.  @addr is not "the starting
> address of memory".
> 
> > +unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
> > +{
> > +	struct list_head *_chunk;
> > +	struct gen_pool_chunk *chunk;
> > +
> > +	read_lock(&pool->lock);
> > +	list_for_each(_chunk, &pool->chunks) {
> > +		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
> > +
> > +		if (addr >= chunk->start_addr && addr < chunk->end_addr)
> > +			return chunk->phys_addr + addr - chunk->start_addr;
> 
> It is in fact "some address within one of the chunks".
yes
do you want a v2 or you fix it in your patch?
> 
> 
> > +	}
> > +	read_unlock(&pool->lock);
> > +
> > +	return ~0UL;
> > +}
> > +EXPORT_SYMBOL(gen_pool_virt_to_phys);
> 
> Was that intentional?  If so, what is the reasoning?
yes as 0 can be a valid physical address
and the export as the drivers can be compiled as module
> 
> 
> Please review...
> 
> Subject: lib/genpool.c: document return values, fix gen_pool_add_virt() return value
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Jes Sorensen <jes@wildopensource.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/genalloc.h |    2 ++
>  lib/genalloc.c           |    6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
