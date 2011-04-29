Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396Ab1D2R0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:26:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45975 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759991Ab1D2R0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:26:02 -0400
Message-ID: <4DBAF498.40007@kernel.org>
Date: Fri, 29 Apr 2011 10:25:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/25] x86, NUMA: trivial cleanups
References: <1304090924-8197-1-git-send-email-tj@kernel.org> <1304090924-8197-9-git-send-email-tj@kernel.org>
In-Reply-To: <1304090924-8197-9-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DBAF49D.00E4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 08:28 AM, Tejun Heo wrote:
> * Kill no longer used struct bootnode.
> 
> * Kill dangling declaration of pxm_to_nid() in numa_32.h.
> 
> * Make setup_node_bootmem() static.

first one and third one should appear in patches that I posted before.

Yinghai

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/include/asm/acpi.h    |    2 --
>  arch/x86/include/asm/amd_nb.h  |    1 -
>  arch/x86/include/asm/numa_32.h |    2 --
>  arch/x86/include/asm/numa_64.h |    7 -------
>  arch/x86/mm/numa_64.c          |    2 +-
>  5 files changed, 1 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> index 12e0e7d..416d865 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -183,8 +183,6 @@ static inline void disable_acpi(void) { }
>  
>  #define ARCH_HAS_POWER_INIT	1
>  
> -struct bootnode;
> -
>  #ifdef CONFIG_ACPI_NUMA
>  extern int acpi_numa;
>  extern int x86_acpi_numa_init(void);
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index 3316822..67f87f2 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -11,7 +11,6 @@ struct amd_nb_bus_dev_range {
>  
>  extern const struct pci_device_id amd_nb_misc_ids[];
>  extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
> -struct bootnode;
>  
>  extern bool early_is_amd_nb(u32 value);
>  extern int amd_cache_northbridges(void);
> diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
> index 242522f..7e54b64 100644
> --- a/arch/x86/include/asm/numa_32.h
> +++ b/arch/x86/include/asm/numa_32.h
> @@ -3,8 +3,6 @@
>  
>  extern int numa_off;
>  
> -extern int pxm_to_nid(int pxm);
> -
>  #ifdef CONFIG_HIGHMEM
>  extern void set_highmem_pages_init(void);
>  #else
> diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
> index 12461eb..794da6d 100644
> --- a/arch/x86/include/asm/numa_64.h
> +++ b/arch/x86/include/asm/numa_64.h
> @@ -3,18 +3,11 @@
>  
>  #include <linux/nodemask.h>
>  
> -struct bootnode {
> -	u64 start;
> -	u64 end;
> -};
> -
>  #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
>  
>  extern int numa_off;
>  
>  extern unsigned long numa_free_all_bootmem(void);
> -extern void setup_node_bootmem(int nodeid, unsigned long start,
> -			       unsigned long end);
>  
>  #ifdef CONFIG_NUMA
>  /*
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 3598fbf..813a161 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -95,7 +95,7 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
>  }
>  
>  /* Initialize bootmem allocator for a node */
> -void __init
> +static void __init
>  setup_node_bootmem(int nid, unsigned long start, unsigned long end)
>  {
>  	const u64 nd_low = (u64)MAX_DMA_PFN << PAGE_SHIFT;

