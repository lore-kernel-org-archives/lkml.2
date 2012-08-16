Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2HPHGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:06:55 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35776 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab2HPHGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:06:54 -0400
Date: Thu, 16 Aug 2012 10:06:50 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Joonsoo Kim <js1304@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/3] slub: reduce failure of this_cpu_cmpxchg in
 put_cpu_partial() after unfreezing
In-Reply-To: <1340389359-2407-2-git-send-email-js1304@gmail.com>
Message-ID: <alpine.LFD.2.02.1208161006430.2133@tux.localdomain>
References: <yes> <1340389359-2407-1-git-send-email-js1304@gmail.com> <1340389359-2407-2-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2012, Joonsoo Kim wrote:
> In current implementation, after unfreezing, we doesn't touch oldpage,
> so it remain 'NOT NULL'. When we call this_cpu_cmpxchg()
> with this old oldpage, this_cpu_cmpxchg() is mostly be failed.
> 
> We can change value of oldpage to NULL after unfreezing,
> because unfreeze_partial() ensure that all the cpu partial slabs is removed
> from cpu partial list. In this time, we could expect that
> this_cpu_cmpxchg is mostly succeed.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 92f1c0e..531d8ed 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1968,6 +1968,7 @@ int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
>  				local_irq_save(flags);
>  				unfreeze_partials(s);
>  				local_irq_restore(flags);
> +				oldpage = NULL;
>  				pobjects = 0;
>  				pages = 0;
>  				stat(s, CPU_PARTIAL_DRAIN);

Applied, thanks!
