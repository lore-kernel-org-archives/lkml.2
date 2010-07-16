Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab0GPUaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:30:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41455 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256Ab0GPU36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=dp/r1Pc+diNaeuU2tGV6MSXsDPm2FPvtxvlmYmX7mKzKIOZicU9H5bkFekmtwTKI2x
         4aIxqsJZctNxYSeBaksT/WUrGZsdrH0p3HAaCocsdleq4h1MuBESsrpslR77QQ59IIKn
         Ie0bcf/OwYsXGwFYHQUPebUffu7iyytndeAWA=
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com> <AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com> <1279100846.8592.53.camel@e102109-lin.cambridge.arm.com> <4C3D89AC.4040303@cs.helsinki.fi> <1279205891.6664.46.camel@e102109-lin.cambridge.arm.com> <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com> <4C3F2F52.2050101@cs.helsinki.fi> <20100715162805.GA10240@brouette> <20100715191638.GA3694@brouette> <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com> <20100715200012.GA4175@brouette> <F37ABC5E-E9F9-43BD-989E-4185135217D2@gmail.com> <AANLkTimWFTUZTh2-3Bavmwcum2joQluMEDmXx3xjyHqQ@mail.gmail.com> <AANLkTinqZs11kXx5afD4RDsVsy551S5lMnyAUwhdX2Sg@mail.gmail.com> <AANLkTilv7cG9JMkZeO_GftTPWHxiIY5c8Q19pTBZT7Vy@mail.gmail.com> <AANLkTimGMUtzgO5HWHXX5RY-EDET61j6PxzwgILigIef@mail.gmail.com> <4C40271E.9070809@cs.helsinki.fi> <AANLkTimxDBusBSkL0I2g9tsj4gLHaqVFArqcfixfzePh@mail.gmail.com> <4C40A498.5060208@kernel.org>
In-Reply-To: <4C40A498.5060208@kernel.org>
Mime-Version: 1.0 (iPhone Mail 8A293)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <C36A97B2-E6A4-409D-91B8-DED8B086A479@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Damien Wyart <damien.wyart@free.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: iPhone Mail (8A293)
From: Zeno Davatz <zdavatz@gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
Date: Fri, 16 Jul 2010 22:29:59 +0200
To: Yinghai Lu <yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 16.07.2010 um 20:27 schrieb Yinghai Lu <yinghai@kernel.org>:

> it seems that you are using 32bit kernel. please check if this one help.

Thanks! What RC should I patch? 2.6.35-rc5?

Best
Zeno

> Subject: [PATCH -v3] x86,mm: fix 32bit numa sparsemem
> 
> Borislav Petkov <borislav.petkov@amd.com> reported his 32bit numa has problem:
> 
> [    0.000000] Reserving total of 4c00 pages for numa KVA remap
> [    0.000000] kva_start_pfn ~ 32800 max_low_pfn ~ 375fe
> [    0.000000] max_pfn = 238000
> [    0.000000] 8202MB HIGHMEM available.
> [    0.000000] 885MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 375fe000
> [    0.000000]   low ram: 0 - 375fe000
> [    0.000000] alloc (nid=8 100000 - 7ee00000) (1000000 - ffffffff) 1000 1000 => 34e7000
> [    0.000000] alloc (nid=8 100000 - 7ee00000) (1000000 - ffffffff) 200 40 => 34c9d80
> [    0.000000] alloc (nid=0 100000 - 7ee00000) (1000000 - ffffffffffffffff) 180 40 => 34e6140
> [    0.000000] alloc (nid=1 80000000 - c7e60000) (1000000 - ffffffffffffffff) 240 40 => 80000000
> [    0.000000] BUG: unable to handle kernel paging request at 40000000
> [    0.000000] IP: [<c2c8cff1>] __alloc_memory_core_early+0x147/0x1d6
> [    0.000000] *pdpt = 0000000000000000 *pde = f000ff53f000ff00 
> ...
> [    0.000000] Call Trace:
> [    0.000000]  [<c2c8b4f8>] ? __alloc_bootmem_node+0x216/0x22f
> [    0.000000]  [<c2c90c9b>] ? sparse_early_usemaps_alloc_node+0x5a/0x10b
> [    0.000000]  [<c2c9149e>] ? sparse_init+0x1dc/0x499
> [    0.000000]  [<c2c79118>] ? paging_init+0x168/0x1df
> [    0.000000]  [<c2c780ff>] ? native_pagetable_setup_start+0xef/0x1bb
> 
> looks like it allocate much high address for bootmem.
> 
> try to cut limit with get_max_mapped()
> 
> -v3: make alloc_bootmem_node could fallback to other node.
>     just like old alloc_bootmem_node did
> 
> need this patch for 2.6.34 and 2.6.35
> 
> Reported-by: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@kernel.org
> 
> ---
> mm/bootmem.c    |   24 ++++++++++++++++++++----
> mm/page_alloc.c |    3 +++
> 2 files changed, 23 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -3634,6 +3634,9 @@ void * __init __alloc_memory_core_early(
>    int i;
>    void *ptr;
> 
> +    if (limit > get_max_mapped())
> +        limit = get_max_mapped();
> +
>    /* need to go over early_node_map to find out good range for node */
>    for_each_active_range_index_in_nid(i, nid) {
>        u64 addr;
> Index: linux-2.6/mm/bootmem.c
> ===================================================================
> --- linux-2.6.orig/mm/bootmem.c
> +++ linux-2.6/mm/bootmem.c
> @@ -833,15 +833,24 @@ static void * __init ___alloc_bootmem_no
> void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>                   unsigned long align, unsigned long goal)
> {
> +    void *ptr;
> +
>    if (WARN_ON_ONCE(slab_is_available()))
>        return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
> 
> #ifdef CONFIG_NO_BOOTMEM
> -    return __alloc_memory_core_early(pgdat->node_id, size, align,
> +    ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
> +                     goal, -1ULL);
> +    if (ptr)
> +        return ptr;
> +
> +    ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
>                     goal, -1ULL);
> #else
> -    return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
> +    ptr = ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
> #endif
> +
> +    return ptr;
> }
> 
> void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
> @@ -977,14 +986,21 @@ void * __init __alloc_bootmem_low(unsign
> void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
>                       unsigned long align, unsigned long goal)
> {
> +    void *ptr;
> +
>    if (WARN_ON_ONCE(slab_is_available()))
>        return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
> 
> #ifdef CONFIG_NO_BOOTMEM
> -    return __alloc_memory_core_early(pgdat->node_id, size, align,
> +    ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
> +                goal, ARCH_LOW_ADDRESS_LIMIT);
> +    if (ptr)
> +        return ptr;
> +    ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
>                goal, ARCH_LOW_ADDRESS_LIMIT);
> #else
> -    return ___alloc_bootmem_node(pgdat->bdata, size, align,
> +    ptr = ___alloc_bootmem_node(pgdat->bdata, size, align,
>                goal, ARCH_LOW_ADDRESS_LIMIT);
> #endif
> +    return ptr;
> }
