Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab2EDEdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 00:33:22 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59453 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2EDEdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 00:33:21 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, mingo@elte.hu, jeremy@goop.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <1335954040.13683.175.camel@twins>
References: <20120427161727.27082.43096.stgit@abhimanyu> <20120427162401.27082.59387.stgit@abhimanyu> <4F9D32B4.8040002@redhat.com> <1335865176.13683.120.camel@twins> <87obq7ge4d.fsf@linux.vnet.ibm.com> <1335954040.13683.175.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Fri, 04 May 2012 10:02:48 +0530
Message-ID: <87mx5olg5r.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12050404-9574-0000-0000-00000279E68A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2012 12:20:40 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
[...] 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index f96a5b5..8ca33e9 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -19,6 +19,8 @@
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  
> +static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page);
> +
>  #ifdef CONFIG_HAVE_RCU_TABLE_FREE
>  /*
>   * Semi RCU freeing of the page directories.
> @@ -60,6 +62,13 @@ struct mmu_table_batch {
>  extern void tlb_table_flush(struct mmu_gather *tlb);
>  extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
>  
> +#else
> +
> +static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
> +{
> +	tlb_remove_page(tlb, page);
>
tlb_remove_page(tlb, table);

