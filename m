Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2D2N2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab2D2N2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:28:14 -0400
Message-ID: <4F9D41DE.3080100@redhat.com>
Date: Sun, 29 Apr 2012 16:27:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH RFC V6 2/5] kvm : Fold pv_unhalt flag into GET_MP_STATE
 ioctl to aid migration
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423100002.30893.60584.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120423100002.30893.60584.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 01:00 PM, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6faa550..7354c1b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5691,7 +5691,9 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>  				    struct kvm_mp_state *mp_state)
>  {
> -	mp_state->mp_state = vcpu->arch.mp_state;
> +	mp_state->mp_state = (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
> +				vcpu->arch.pv.pv_unhalted) ?
> +	KVM_MP_STATE_RUNNABLE : vcpu->arch.mp_state;
>  	return 0;
>  }

Not pretty.  Suggest rewriting using an if.

-- 
error compiling committee.c: too many arguments to function

