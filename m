Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0FGBSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:18:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62890 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0FGBSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NV4PncsejXT7JbGGVO0blIIGHX4/Dzrg3SvEy6b2CosXIJd2hfqRawjoMvXovTicCL
         LzDHAUwDK/5ux1kLS4vjrE3+zNJOTMWDLNtW3JMzsI6CpjmcFhbNBG/nduW26KZI7JhH
         1qcF8znKrJ8mqF0URlXeXW9qI7slOpLmjjQlg=
MIME-Version: 1.0
In-Reply-To: <bb57bd68cf450bc3430bc072269041355d798b7f.1275739617.git.imre.deak@nokia.com>
References: <bb57bd68cf450bc3430bc072269041355d798b7f.1275739617.git.imre.deak@nokia.com>
Date: Mon, 7 Jun 2010 10:18:45 +0900
Message-ID: <AANLkTineBWUQST53I9xuBNbBnCcHUQghCbr8X16WOHgT@mail.gmail.com>
Subject: Re: [PATCH] genalloc: fix allocation from end of pool
From: Akinobu Mita <akinobu.mita@gmail.com>
To: imre.deak@nokia.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zygo Blaxell <zygo.blaxell@xandros.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/5  <imre.deak@nokia.com>:
> From: Imre Deak <imre.deak@nokia.com>
>
> bitmap_find_next_zero_area requires the size of the bitmap, we instead
> passed the last suitable position. This made it impossible to allocate
> from the end of the pool.

Looks good to me.
This bug was introduced by commit 243797f59b748f679ab88d456fcc4f92236d724b
("genalloc: use bitmap_find_next_zero_area")

> Signed-off-by: Imre Deak <imre.deak@nokia.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Zygo Blaxell <zygo.blaxell@xandros.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Akinobu Mita <akinobu.mita@gmail.com>
>
> ---
>  lib/genalloc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index 736c3b0..1923f14 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -128,7 +128,6 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
>                chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
>
>                end_bit = (chunk->end_addr - chunk->start_addr) >> order;
> -               end_bit -= nbits + 1;
>
>                spin_lock_irqsave(&chunk->lock, flags);
>                start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit, 0,
> --
> 1.7.1
>
>
