Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2JRKrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:47:14 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:55753 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab2JRKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:47:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15251257"
Message-ID: <1350557230.2460.115.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V3 3/6]: PVH:  mmu related changes.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Oct 2012 11:47:10 +0100
In-Reply-To: <20121017173119.4e12b222@mantra.us.oracle.com>
References: <20121017173119.4e12b222@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 01:31 +0100, Mukesh Rathor wrote:
>          * the initial domain. For guests using the toolstack, they are in:
> @@ -2177,8 +2210,20 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
> 
>  void __init xen_init_mmu_ops(void)
>  {
> -       x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
>         x86_init.paging.pagetable_init = xen_pagetable_init;
> +
> +       if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +               pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
> +#if 0

I don't recall seeing this #if 0 before -- is it new and/or deliberate?

If it is a marker for future work can we leave it out for now?

> +               /* For PCI devices to map iomem. */
> +               if (xen_initial_domain()) {
> +                       pv_mmu_ops.set_pte = native_set_pte;
> +                       pv_mmu_ops.set_pte_at = native_set_pte_at;
> +               }
> +#endif
> +               return;
> +       }
> +       x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
>         pv_mmu_ops = xen_mmu_ops;
> 


