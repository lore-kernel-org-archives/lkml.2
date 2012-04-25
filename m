Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2DYHPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:15:36 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50958 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2DYHPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:15:35 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-5f-4f97a495c1f7
Message-ID: <4F97A4B6.3010305@kernel.org>
Date: Wed, 25 Apr 2012 16:16:06 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: A potential bug in mm/memblock.c?
References: <CAHnt0GWDqsGsj_i1u3aRSMa1ie4EAhS9GN_D=m1jx5gk6nYgwg@mail.gmail.com>
In-Reply-To: <CAHnt0GWDqsGsj_i1u3aRSMa1ie4EAhS9GN_D=m1jx5gk6nYgwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 03:27 PM, Peter Teoh wrote:

> Comments please.   Thanks.


barrios@bbox:~/linux-next$ ./scripts/get_maintainer.pl -f mm/memblock.c
Tejun Heo <tj@kernel.org> (commit_signer:32/36=89%)
"H. Peter Anvin" <hpa@linux.intel.com> (commit_signer:15/36=42%)
Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/36=11%)
Ingo Molnar <mingo@elte.hu> (commit_signer:2/36=6%)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
linux-kernel@vger.kernel.org (open list)

Please Cced them and write down the description which should include
problem and how to fix. And it would be better to use more clear subject.

[BUG]memblock: fix overflow of array index

Anyway,

Reviewed-by: Minchan Kim <minchan@kernel.org>

> 
> Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index a44eab3..2c621c5 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -553,8 +553,8 @@ void __init_memblock __next_free_mem_range(u64
> *idx, int nid,
>  {
>        struct memblock_type *mem = &memblock.memory;
>        struct memblock_type *rsv = &memblock.reserved;
> -       int mi = *idx & 0xffffffff;
> -       int ri = *idx >> 32;
> +       unsigned int mi = *idx & 0xffffffff;
> +       unsigned int ri = *idx >> 32;
> 
>        for ( ; mi < mem->cnt; mi++) {
>                struct memblock_region *m = &mem->regions[mi];
> 
> 
> 



-- 
Kind regards,
Minchan Kim
