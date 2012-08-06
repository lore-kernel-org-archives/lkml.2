Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2HFPB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:01:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38398 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2HFPB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:01:57 -0400
Date: Mon, 6 Aug 2012 10:52:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Millenbach <jmillenbach@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, team-fjord@googlegroups.com
Subject: Re: [PATCH] x86: Changing date reference in CONFIG_SWIOTLB help from
 a relative to fixed point
Message-ID: <20120806145216.GE2487@phenom.dumpdata.com>
References: <1344143521-30151-1-git-send-email-jmillenbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344143521-30151-1-git-send-email-jmillenbach@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 10:12:01PM -0700, Joe Millenbach wrote:
> CONFIG_SWIOTLB's existing help information refers to "the current
> generation of Intel's x86-64 CPUs", but the statement is no longer
> true.  After researching on Intel's ark site, I changed the statement
> to the also true "all Intel CPUs released before 2008".
> 
> Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  arch/x86/Kconfig |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5bed94e..dadbfd6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -755,10 +755,10 @@ config SWIOTLB
>  	def_bool y if X86_64
>  	---help---
>  	  Support for software bounce buffers used on x86-64 systems
> -	  which don't have a hardware IOMMU (e.g. the current generation
> -	  of Intel's x86-64 CPUs). Using this PCI devices which can only
> -	  access 32-bits of memory can be used on systems with more than
> -	  3 GB of memory. If unsure, say Y.
> +	  which don't have a hardware IOMMU (e.g. all Intel CPUs released
> +	  before 2008). Using this PCI devices which can only access 32-bits
> +	  of memory can be used on systems with more than 3 GB of memory. If
> +	  unsure, say Y.

It actually should have that part about Intel CPUs removed - as the hardware
IOMMUs have nothing to do with the CPU. For example the SWIOTLB is used
on the AMD IOMMUs if the IOMMU does not cover certain devices.
So is the case with the IBM Calgary.

>  
>  config IOMMU_HELPER
>  	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
