Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0DCRWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 13:22:32 -0400
Received: from 8bytes.org ([88.198.83.132]:39715 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab0DCRW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 13:22:26 -0400
Date: Sat, 3 Apr 2010 19:22:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, nhorman@redhat.com,
       nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, ebiederm@xmission.com,
       vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
Message-ID: <20100403172224.GO24846@8bytes.org>
References: <20100403012751.834020949@sous-sol.org> <20100403012820.229410717@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403012820.229410717@sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 06:27:54PM -0700, Chris Wright wrote:
> This effectively reverts commit 61d047be99757fd9b0af900d7abce9a13a337488.
> 
> Disabling the IOMMU can potetially allow DMA transactions to
> complete without being translated.  Leave it enabled, and allow
> crash kernel to do the IOMMU reinitialization properly.
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  arch/x86/kernel/crash.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -27,7 +27,6 @@
>  #include <asm/cpu.h>
>  #include <asm/reboot.h>
>  #include <asm/virtext.h>
> -#include <asm/x86_init.h>
>  
>  #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
>  
> @@ -103,10 +102,5 @@ void native_machine_crash_shutdown(struc
>  #ifdef CONFIG_HPET_TIMER
>  	hpet_disable();
>  #endif
> -
> -#ifdef CONFIG_X86_64
> -	x86_platform.iommu_shutdown();
> -#endif
> -
>  	crash_save_cpu(regs, safe_smp_processor_id());

Hmm, I think for this we need to change the gart code too and disable
the gart before its initialization runs to not re-introduce issues fixed
in commit bc2cea6a34fdb30f118ec75db39a46a191870607, no?

	Joerg

