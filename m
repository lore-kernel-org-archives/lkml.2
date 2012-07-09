Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2GIOuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:50:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16406 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2GIOuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:50:21 -0400
Date: Mon, 9 Jul 2012 10:41:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org
Subject: Re: [PATCH WIP 1/6] xen/arm: fix the shared_info and vcpu_info
 structs
Message-ID: <20120709144156.GC12102@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 05:14:40PM +0100, Stefano Stabellini wrote:
> Fix the shared_info and vcpu_info struct definitions to match the ones
> in Xen.

Is there a corresponding c/s in the Xen tree for this?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/include/asm/xen/interface.h |   15 +++------------
>  1 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
> index 3ad2d4b..8ab7cebb 100644
> --- a/arch/arm/include/asm/xen/interface.h
> +++ b/arch/arm/include/asm/xen/interface.h
> @@ -40,19 +40,10 @@ DEFINE_GUEST_HANDLE(xen_pfn_t);
>  #endif
>  
>  /* Maximum number of virtual CPUs in multi-processor guests. */
> -#define MAX_VIRT_CPUS 32
> +#define MAX_VIRT_CPUS 1
>  
> -struct arch_vcpu_info {
> -    unsigned long cr2;
> -    unsigned long pad; /* sizeof(vcpu_info_t) == 64 */
> -};
> -
> -struct arch_shared_info {
> -    unsigned long max_pfn;                  /* max pfn that appears in table */
> -    /* Frame containing list of mfns containing list of mfns containing p2m. */
> -    unsigned long pfn_to_mfn_frame_list_list;
> -    unsigned long nmi_reason;
> -};
> +struct arch_vcpu_info { };
> +struct arch_shared_info { };
>  
>  /* XXX: Move pvclock definitions some place arch independent */
>  struct pvclock_vcpu_time_info {
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
