Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2EAHYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 03:24:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2EAHYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 03:24:35 -0400
Date: Tue, 1 May 2012 10:24:25 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kvm: fix cpuid eax
Message-ID: <20120501072425.GC22191@redhat.com>
References: <20120430143902.GA10181@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430143902.GA10181@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 05:39:03PM +0300, Michael S. Tsirkin wrote:
> cpuid eax should return the max leaf so that
> guests can find out the valid range.
> This matches Xen et al.
> 
> Tested using -cpu host.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
>  arch/x86/kvm/cpuid.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7d00d2d..bda4877 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -397,7 +397,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  	case KVM_CPUID_SIGNATURE: {
>  		char signature[12] = "KVMKVMKVM\0\0";
>  		u32 *sigptr = (u32 *)signature;
> -		entry->eax = 0;
> +		entry->eax = KVM_CPUID_FEATURES;
>  		entry->ebx = sigptr[0];
>  		entry->ecx = sigptr[1];
>  		entry->edx = sigptr[2];
> -- 
> MST
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
