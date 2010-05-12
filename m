Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0ELH3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:29:15 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:12631 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab0ELH3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:29:13 -0400
Message-ID: <4BEA58C6.7030103@bfs.de>
Date: Wed, 12 May 2010 09:29:10 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       ", H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] arch/x86/kernel: Drop memory allocation cast
References: <Pine.LNX.4.64.1005112028160.4330@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005112028160.4330@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Julia Lawall schrieb:
> From: Julia Lawall <julia@diku.dk>
> 
> Drop cast on the result of kmalloc and similar functions.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> @@
> 
> - (T *)
>   (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
>    kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/x86/kernel/tlb_uv.c            |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
> index 7fea555..9064179 100644
> --- a/arch/x86/kernel/tlb_uv.c
> +++ b/arch/x86/kernel/tlb_uv.c
> @@ -1141,7 +1141,7 @@ uv_activation_descriptor_init(int node, int pnode)
>  	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
>  	 * per cpu; and up to 32 (UV_ADP_SIZE) cpu's per uvhub
>  	 */
> -	bau_desc = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
> +	bau_desc = kmalloc_node(sizeof(struct bau_desc) *
>  		UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
>  	BUG_ON(!bau_desc);
>  
> @@ -1200,7 +1200,7 @@ uv_payload_queue_init(int node, int pnode)
>  	struct bau_payload_queue_entry *pqp_malloc;
>  	struct bau_control *bcp;
>  
> -	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
> +	pqp = kmalloc_node(
>  		(DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry),
>  		GFP_KERNEL, node);
>  	BUG_ON(!pqp);
> @@ -1286,8 +1286,7 @@ static void uv_init_per_cpu(int nuvhubs)
>  	};
>  	struct uvhub_desc *uvhub_descs;
>  
> -	uvhub_descs = (struct uvhub_desc *)
> -		kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
> +	uvhub_descs = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
>  	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
>  	for_each_present_cpu(cpu) {
>  		bcp = &per_cpu(bau_control, cpu);

kzmalloc() ?

BUG_ON(!uvhub_descs); ?

re,
 wh
