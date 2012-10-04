Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab2JDRfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:35:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35840 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932253Ab2JDRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:35:17 -0400
Date: Thu, 4 Oct 2012 18:35:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>, Avi Kivity <avi@redhat.com>
Message-ID: <20121004173513.GC13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225159.521191640@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225159.521191640@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 045/180] KVM: Ensure all vcpus are consistent with in-kernel
 irqchip settings
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:52:42AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Avi Kivity <avi@redhat.com>
> 
> commit 3e515705a1f46beb1c942bb8043c16f8ac7b1e9e upstream
[...]
> --- a/arch/ia64/kvm/kvm-ia64.c
> +++ b/arch/ia64/kvm/kvm-ia64.c
> @@ -1185,6 +1185,11 @@ out:
>  
>  #define PALE_RESET_ENTRY    0x80000000ffffffb0UL
>  
> +bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu)
> +{
> +	return irqchip_in_kernel(vcpu->kcm) == (vcpu->arch.apic != NULL);
> +}
> +
[...]

Fails to build; fixed by commit 8281715b4109b5ee26032ff7b77c0d575c4150f7.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
