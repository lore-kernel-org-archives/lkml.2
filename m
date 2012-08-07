Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2HGSme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:42:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25295 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab2HGSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:42:33 -0400
Date: Tue, 7 Aug 2012 14:32:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 20/23] xen/arm: compile netback
Message-ID: <20120807183235.GW15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-20-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-20-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:23PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

OK. Looks good.
> ---
>  arch/arm/include/asm/xen/hypercall.h |   19 +++++++++++++++++++
>  drivers/net/xen-netback/netback.c    |    1 +
>  drivers/net/xen-netfront.c           |    1 +
>  3 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
> index 4ac0624..8a82325 100644
> --- a/arch/arm/include/asm/xen/hypercall.h
> +++ b/arch/arm/include/asm/xen/hypercall.h
> @@ -47,4 +47,23 @@ unsigned long HYPERVISOR_hvm_op(int op, void *arg);
>  int HYPERVISOR_memory_op(unsigned int cmd, void *arg);
>  int HYPERVISOR_physdev_op(int cmd, void *arg);
>  
> +static inline void
> +MULTI_update_va_mapping(struct multicall_entry *mcl, unsigned long va,
> +			unsigned int new_val, unsigned long flags)
> +{
> +	BUG();
> +}
> +
> +static inline void
> +MULTI_mmu_update(struct multicall_entry *mcl, struct mmu_update *req,
> +		 int count, int *success_count, domid_t domid)
> +{
> +	BUG();
> +}
> +
> +static inline int
> +HYPERVISOR_multicall(void *call_list, int nr_calls)
> +{
> +	BUG();
> +}
>  #endif /* _ASM_ARM_XEN_HYPERCALL_H */
> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index f4a6fca..ab4f81c 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -40,6 +40,7 @@
>  
>  #include <net/tcp.h>
>  
> +#include <xen/xen.h>
>  #include <xen/events.h>
>  #include <xen/interface/memory.h>
>  
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 3089990..bf4ba2b 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -43,6 +43,7 @@
>  #include <linux/slab.h>
>  #include <net/ip.h>
>  
> +#include <asm/xen/page.h>
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
>  #include <xen/events.h>
> -- 
> 1.7.2.5
