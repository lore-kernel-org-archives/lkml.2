Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2F1BcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:32:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25504 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2F1BcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:32:11 -0400
Date: Wed, 27 Jun 2012 21:24:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] kvm, Add x86_hyper_kvm to complete
 detect_hypervisor_platform check
Message-ID: <20120628012419.GA8956@phenom.dumpdata.com>
References: <1340833338-15485-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340833338-15485-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 05:42:18PM -0400, Prarit Bhargava wrote:
> While debugging I noticed that unlike all the other hypervisor code in the
> kernel, kvm does not have an entry for x86_hyper which is used in
> detect_hypervisor_platform(), and results in a nice message about the
> hypervisor being used.  This is only really a stub function and it makes
> kvm more consistent with the other hypervisors (and it makes debugging
> a little easier).
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> ---
>  arch/x86/include/asm/hypervisor.h |    1 +
>  arch/x86/kernel/cpu/hypervisor.c  |    1 +
>  arch/x86/kernel/kvm.c             |    6 ++++++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
> index 7a15153..b518c75 100644
> --- a/arch/x86/include/asm/hypervisor.h
> +++ b/arch/x86/include/asm/hypervisor.h
> @@ -49,6 +49,7 @@ extern const struct hypervisor_x86 *x86_hyper;
>  extern const struct hypervisor_x86 x86_hyper_vmware;
>  extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
>  extern const struct hypervisor_x86 x86_hyper_xen_hvm;
> +extern const struct hypervisor_x86 x86_hyper_kvm;
>  
>  static inline bool hypervisor_x2apic_available(void)
>  {
> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> index 755f64f..6d6dd7a 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -37,6 +37,7 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
>  #endif
>  	&x86_hyper_vmware,
>  	&x86_hyper_ms_hyperv,
> +	&x86_hyper_kvm,
>  };
>  
>  const struct hypervisor_x86 *x86_hyper;
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index e554e5a..0a38b68 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -39,6 +39,7 @@
>  #include <asm/desc.h>
>  #include <asm/tlbflush.h>
>  #include <asm/idle.h>
> +#include <asm/hypervisor.h>
>  
>  static int kvmapf = 1;
>  
> @@ -432,6 +433,11 @@ void __init kvm_guest_init(void)
>  #endif
>  }
>  
> +const struct hypervisor_x86 x86_hyper_kvm __refconst = {
> +	.name			= "KVM",
> +};
> +EXPORT_SYMBOL(x86_hyper_kvm);

EXPORT_SYMBOL_GPL version. ?

> +
>  static __init int activate_jump_labels(void)
>  {
>  	if (has_steal_clock) {
> -- 
> 1.7.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
