Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2CHKkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:40:55 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:21566
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab2CHKkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:40:51 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0KAZQ-02-8VS-02
X-M-MSG: 
Date: Thu, 8 Mar 2012 11:40:38 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jason Wang <jasowang@redhat.com>
CC: <mtosatti@redhat.com>, <avi@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: svm: count all irq windows exit
Message-ID: <20120308104038.GQ10684@amd.com>
References: <20120308100756.3984.25343.stgit@amd-6168-8-1.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120308100756.3984.25343.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 06:07:56PM +0800, Jason Wang wrote:
> Also count the exits of fast-path.

And align it with how it is counted in VMX.

> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kvm/svm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 53efd59..5ef7233 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3235,6 +3235,7 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
>  	svm_clear_vintr(svm);
>  	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
>  	mark_dirty(svm->vmcb, VMCB_INTR);
> +	++svm->vcpu.stat.irq_window_exits;
>  	/*
>  	 * If the user space waits to inject interrupts, exit as soon as
>  	 * possible
> @@ -3242,7 +3243,6 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
>  	if (!irqchip_in_kernel(svm->vcpu.kvm) &&
>  	    kvm_run->request_interrupt_window &&
>  	    !kvm_cpu_has_interrupt(&svm->vcpu)) {
> -		++svm->vcpu.stat.irq_window_exits;
>  		kvm_run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
>  		return 0;
>  	}
> 

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

