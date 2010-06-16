Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab0FPNwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:52:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758785Ab0FPNwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:52:15 -0400
Date: Wed, 16 Jun 2010 10:52:11 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] TSC reset compensation
Message-ID: <20100616135211.GL19104@mothafucka.localdomain>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
 <1276587259-32319-17-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276587259-32319-17-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 09:34:18PM -1000, Zachary Amsden wrote:
> Attempt to synchronize TSCs which are reset to the same value.  In the
> case of a reliable hardware TSC, we can just re-use the same offset, but
> on non-reliable hardware, we can get closer by adjusting the offset to
> match the elapsed time.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/kvm/x86.c |   34 ++++++++++++++++++++++++++++++++--
>  1 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8e836e9..cedb71f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -937,14 +937,44 @@ static inline void kvm_request_guest_time_update(struct kvm_vcpu *v)
>  	set_bit(KVM_REQ_CLOCK_SYNC, &v->requests);
>  }
>  
> +static inline int kvm_tsc_reliable(void)
> +{
> +	return (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
> +		boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
> +		!check_tsc_unstable());
> +}
> +
why can't we re-use vmware TSC_RELIABLE flag?


