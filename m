Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0GZWGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:06:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37775 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0GZWGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:06:19 -0400
MIME-Version: 1.0
In-Reply-To: <20100726220405.1550.63442.stgit@angua>
References: <20100726220405.1550.63442.stgit@angua>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 26 Jul 2010 16:05:58 -0600
X-Google-Sender-Auth: E7U5H3Cw1OrzdMNQAQchxsDzzCE
Message-ID: <AANLkTi=2nb5oQ47Uzf+vDz0uT+O3_xrbV3bbo-WafCMq@mail.gmail.com>
Subject: Re: [PATCH v3] of: Create asm-generic/of.h and provide default 
	of_node_to_nid()
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 4:04 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> of_node_to_nid() is only relevant in a few architectures.  Don't force
> everyone to implement it anyway.  This patch also adds asm-generic/of.h
> which will be used to contain other overrideable symbols.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Oops.  The patch subject I will change before mergine.

g.

> ---
>
> Changes in v3: don't use asm-generic, just keep macros in of.h
> Changes in v2: address comments from sfr, add asm-generic/of.h
>
>  arch/microblaze/include/asm/topology.h |   10 ----------
>  arch/powerpc/include/asm/prom.h        |    5 +++++
>  arch/powerpc/include/asm/topology.h    |    7 -------
>  arch/sparc/include/asm/prom.h          |    1 +
>  include/linux/of.h                     |    5 +++++
>  5 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/arch/microblaze/include/asm/topology.h b/arch/microblaze/include/asm/topology.h
> index 96bcea5..5428f33 100644
> --- a/arch/microblaze/include/asm/topology.h
> +++ b/arch/microblaze/include/asm/topology.h
> @@ -1,11 +1 @@
>  #include <asm-generic/topology.h>
> -
> -#ifndef _ASM_MICROBLAZE_TOPOLOGY_H
> -#define _ASM_MICROBLAZE_TOPOLOGY_H
> -
> -struct device_node;
> -static inline int of_node_to_nid(struct device_node *device)
> -{
> -       return 0;
> -}
> -#endif /* _ASM_MICROBLAZE_TOPOLOGY_H */
> diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
> index da7dd63..dca25a5 100644
> --- a/arch/powerpc/include/asm/prom.h
> +++ b/arch/powerpc/include/asm/prom.h
> @@ -103,6 +103,11 @@ struct device_node *of_find_next_cache_node(struct device_node *np);
>  /* Get the MAC address */
>  extern const void *of_get_mac_address(struct device_node *np);
>
> +#ifdef CONFIG_NUMA
> +extern int of_node_to_nid(struct device_node *device);
> +#define of_node_to_nid of_node_to_nid
> +#endif
> +
>  /**
>  * of_irq_map_pci - Resolve the interrupt for a PCI device
>  * @pdev:      the device whose interrupt is to be resolved
> diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
> index 32adf72..09dd38c 100644
> --- a/arch/powerpc/include/asm/topology.h
> +++ b/arch/powerpc/include/asm/topology.h
> @@ -41,8 +41,6 @@ static inline int cpu_to_node(int cpu)
>                               cpu_all_mask :                           \
>                               node_to_cpumask_map[node])
>
> -int of_node_to_nid(struct device_node *device);
> -
>  struct pci_bus;
>  #ifdef CONFIG_PCI
>  extern int pcibus_to_node(struct pci_bus *bus);
> @@ -94,11 +92,6 @@ extern void sysfs_remove_device_from_node(struct sys_device *dev, int nid);
>
>  #else
>
> -static inline int of_node_to_nid(struct device_node *device)
> -{
> -       return 0;
> -}
> -
>  static inline void dump_numa_cpu_topology(void) {}
>
>  static inline int sysfs_add_device_to_node(struct sys_device *dev, int nid)
> diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
> index c82a7da..73befa5 100644
> --- a/arch/sparc/include/asm/prom.h
> +++ b/arch/sparc/include/asm/prom.h
> @@ -43,6 +43,7 @@ extern int of_getintprop_default(struct device_node *np,
>  extern int of_find_in_proplist(const char *list, const char *match, int len);
>  #ifdef CONFIG_NUMA
>  extern int of_node_to_nid(struct device_node *dp);
> +#define of_node_to_nid of_node_to_nid
>  #else
>  #define of_node_to_nid(dp)     (-1)
>  #endif
> diff --git a/include/linux/of.h b/include/linux/of.h
> index b0756f3..cc936ca 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -146,6 +146,11 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
>
>  #define OF_BAD_ADDR    ((u64)-1)
>
> +#ifndef of_node_to_nid
> +static inline int of_node_to_nid(struct device_node *np) { return 0; }
> +#define of_node_to_nid of_node_to_nid
> +#endif
> +
>  extern struct device_node *of_find_node_by_name(struct device_node *from,
>        const char *name);
>  #define for_each_node_by_name(dn, name) \
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
