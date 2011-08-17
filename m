Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1HQKh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:37:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55908 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab1HQKhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:37:23 -0400
Date: Wed, 17 Aug 2011 12:37:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: Allow ZONE_DMA to be configurable
Message-ID: <20110817103717.GA5172@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, mingo@redhat.com,
	hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
	rientjes@google.com, hpa@linux.intel.com,
	linux-tip-commits@vger.kernel.org
References: <alpine.DEB.2.00.1105161353560.4353@chino.kir.corp.google.com>
 <tip-dc382fd5bcca7098a984705ed6ac880f539d068e@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-dc382fd5bcca7098a984705ed6ac880f539d068e@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 11:13:07PM +0000, tip-bot for David Rientjes wrote:
> Commit-ID:  dc382fd5bcca7098a984705ed6ac880f539d068e
> Gitweb:     http://git.kernel.org/tip/dc382fd5bcca7098a984705ed6ac880f539d068e
> Author:     David Rientjes <rientjes@google.com>
> AuthorDate: Mon, 16 May 2011 13:54:10 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Mon, 16 May 2011 14:03:28 -0700
> 
> x86, mm: Allow ZONE_DMA to be configurable
> 
> ZONE_DMA is unnecessary for a large number of machines that do not
> require less than 32-bit DMA addressing, e.g. ISA legacy DMA or PCI
> cards with a restricted DMA address mask.
> 
> This patch allows users to disable ZONE_DMA for x86 if they know they
> will not be using such devices with their kernel.
> 
> This prevents the VM from unnecessarily reserving a ratio of memory
> (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> for such allocations when it will never be used.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1105161353560.4353@chino.kir.corp.google.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

This causes the ZONE_DMA menu option to appear in the toplevel menu of
the kernel configurator instead of under EXPERT, where it should belong
IMO.

> ---
>  arch/x86/Kconfig      |    9 ++++++++-
>  arch/x86/mm/init_32.c |    2 ++
>  arch/x86/mm/init_64.c |    2 ++
>  3 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 648fca4..0eb801a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -112,7 +112,14 @@ config MMU
>  	def_bool y
>  
>  config ZONE_DMA
> -	def_bool y
> +	bool "DMA memory allocation support" if EXPERT
> +	default y
> +	help
> +	  DMA memory allocation support allows devices with less than 32-bit
> +	  addressing to allocate within the first 16MB of address space.
> +	  Disable if no such devices will be used.
> +
> +	  If unsure, say Y.

maybe this should go into init/Kconfig ?

Thanks.

-- 
Regards/Gruss,
    Boris.
