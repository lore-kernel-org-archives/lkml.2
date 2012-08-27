Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2H0Uya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:54:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab2H0Uy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:54:28 -0400
Date: Mon, 27 Aug 2012 17:47:42 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-3.6] kvm: fix KVM_GET_MSR for PV EOI
Message-ID: <20120827204742.GA5031@amt.cnet>
References: <20120826150029.GA11114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826150029.GA11114@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 06:00:29PM +0300, Michael S. Tsirkin wrote:
> KVM_GET_MSR was missing support for PV EOI,
> which is needed for migration.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Please consider this bugfix patch for 3.6.
> Thanks!
> 
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 91a5958..ff5e985 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1993,6 +1993,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  	case MSR_KVM_STEAL_TIME:
>  		data = vcpu->arch.st.msr_val;
>  		break;
> +	case MSR_KVM_PV_EOI_EN:
> +		data = vcpu->arch.pv_eoi.msr_val;
> +		break;
>  	case MSR_IA32_P5_MC_ADDR:
>  	case MSR_IA32_P5_MC_TYPE:
>  	case MSR_IA32_MCG_CAP:

Should increase KVM_SAVE_MSRS_BEGIN.
