Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1G1Kjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:39:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33493 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1G1Kjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <1311664741-21336-1-git-send-email-leoy@marvell.com>
References: <1311664741-21336-1-git-send-email-leoy@marvell.com>
Date: Thu, 28 Jul 2011 18:39:44 +0800
Message-ID: <CAMk6uBmE01EpAw3e8kB9v6tEkU0rAPqt8T7+k54QDzDxtDn7PQ@mail.gmail.com>
Subject: Re: [PATCH] lib/genalloc: fix gen_pool_virt_to_phys locking
From: real mz <realmz6@gmail.com>
To: Leo Yan <leoy@marvell.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ying.huang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this fix seems already on next tree

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=lib/genalloc.c;h=f352cc42f4f8a58b8e4c8304de32cb31b4e29b67;hb=HEAD


On Tue, Jul 26, 2011 at 3:19 PM, Leo Yan <leoy@marvell.com> wrote:
> The func gen_pool_virt_to_phys will iterate the chunk list;
> if find the correct chunk it should need release pool's lock.
>
> Signed-off-by: Leo Yan <leoy@marvell.com>
> ---
>  lib/genalloc.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index 577ddf8..e625df5 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -92,8 +92,10 @@ phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
>        list_for_each(_chunk, &pool->chunks) {
>                chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>
> -               if (addr >= chunk->start_addr && addr < chunk->end_addr)
> +               if (addr >= chunk->start_addr && addr < chunk->end_addr) {
> +                       read_unlock(&pool->lock);
>                        return chunk->phys_addr + addr - chunk->start_addr;
> +               }
>        }
>        read_unlock(&pool->lock);
>
> --
> 1.7.4.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
