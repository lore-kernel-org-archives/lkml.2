Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1BVXst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:48:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755830Ab1BVXss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:48:48 -0500
Date: Tue, 22 Feb 2011 15:48:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] mm: Move contig_page_data define to
 bootmem.c/nobootmem.c
Message-Id: <20110222154806.0be18267.akpm@linux-foundation.org>
In-Reply-To: <1297120632-24933-11-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
	<1297120632-24933-11-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Feb 2011 15:17:11 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> We can remove #ifdef in mm/page_alloc.c
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  mm/bootmem.c    |    7 +++++++
>  mm/nobootmem.c  |    5 +++++
>  mm/page_alloc.c |    9 ---------
>  3 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 4403e2f..79d9c3c 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -23,6 +23,13 @@
>  
>  #include "internal.h"
>  
> +#ifndef CONFIG_NEED_MULTIPLE_NODES
> +struct pglist_data __refdata contig_page_data = {
> + .bdata = &bootmem_node_data[0]
> + };
> +EXPORT_SYMBOL(contig_page_data);
> +#endif

Please fix the layout when moving this code - it's quite busted and as
we're touching the code anyway, we might as well fix it up.

Patches 9, 10 and 11 look good to me and won't conflict with ther
pending work - please merge them up via the appropriate ingotree.

