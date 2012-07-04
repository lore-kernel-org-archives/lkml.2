Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab2GDNAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:00:53 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39430 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2GDNAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:00:51 -0400
MIME-Version: 1.0
In-Reply-To: <1340390729-2821-1-git-send-email-js1304@gmail.com>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com>
	<1340390729-2821-1-git-send-email-js1304@gmail.com>
Date: Wed, 4 Jul 2012 16:00:49 +0300
X-Google-Sender-Auth: IvuuLUkNJbdJHb57nTA8qeuG7H4
Message-ID: <CAOJsxLHSboF0rQdGv8bdgGtinBz5dTo+omQbUnj9on_ewzgNAQ@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] slub: prefetch next freelist pointer in __slab_alloc()
From: Pekka Enberg <penberg@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 9:45 PM, Joonsoo Kim <js1304@gmail.com> wrote:
> Commit 0ad9500e16fe24aa55809a2b00e0d2d0e658fc71 ('slub: prefetch
> next freelist pointer in slab_alloc') add prefetch instruction to
> fast path of allocation.
>
> Same benefit is also available in slow path of allocation, but it is not
> large portion of overall allocation. Nevertheless we could get
> some benifit from it, so prefetch next freelist pointer in __slab_alloc.
>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> ---
> Add 'Cc: Eric Dumazet <eric.dumazet@gmail.com>'
>
> diff --git a/mm/slub.c b/mm/slub.c
> index f96d8bc..92f1c0e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2248,6 +2248,7 @@ load_freelist:
>         VM_BUG_ON(!c->page->frozen);
>         c->freelist = get_freepointer(s, freelist);
>         c->tid = next_tid(c->tid);
> +       prefetch_freepointer(s, c->freelist);
>         local_irq_restore(flags);
>         return freelist;

Well, can you show improvement in any benchmark or workload?
Prefetching is not always an obvious win and the reason we merged
Eric's patch was that he was able to show an improvement in hackbench.
