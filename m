Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1DLLtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:49:33 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:54155 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1DLLtc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:8:1>);
	Tue, 12 Apr 2011 07:49:32 -0400
Message-Id: <4DA458AB020000780003B107@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 12 Apr 2011 12:50:35 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>
Cc: <mingo@elte.hu>, <jeremy@goop.org>, <yinghai@kernel.org>,
        <hpa@linux.intel.com>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 2/4] x86, xen: introduce
	 x86_init.mapping.pagetable_reserve
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
 <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.04.11 at 13:19, <stefano.stabellini@eu.citrix.com> wrote:
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 6b833db..fec8680 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1275,6 +1275,20 @@ static __init void xen_pagetable_setup_start(pgd_t 
> *base)
>  {
>  }
>  
> +static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
> +{
> +	/* reserve the range used */
> +	memblock_x86_reserve_range(start, end, "PGTABLE");

Wouldn't it be more natural (and involving less future changes) if
you called native_pagetable_reserve() here?

Jan

> +
> +	/* set as RW the rest */
> +	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
> +			PFN_PHYS(pgt_buf_top));
> +	while (end < PFN_PHYS(pgt_buf_top)) {
> +		make_lowmem_page_readwrite(__va(end));
> +		end += PAGE_SIZE;
> +	}
> +}
> +
>  static void xen_post_allocator_init(void);
>  
>  static __init void xen_pagetable_setup_done(pgd_t *base)


