Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab1AMPtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:49:22 -0500
Received: from thoth.sbs.de ([192.35.17.2]:18161 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab1AMPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:49:18 -0500
Message-ID: <4D2F1ED1.1020001@siemens.com>
Date: Thu, 13 Jan 2011 16:48:33 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Fix NMI path when NMI happens in guest
 mode
References: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com> <1294932178-26866-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1294932178-26866-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.01.2011 16:22, Joerg Roedel wrote:
> The vmexit path on SVM needs to restore the KERNEL_GS_BASE
> MSR in order to savely execute the NMI handler. Otherwise a
> pending NMI can occur after the STGI instruction and crash
> the machine.
> This makes it impossible to run perf and kvm in parallel on
> an AMD machine in a stable way.
> 
> Cc: stable@kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/svm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 25bd1bc..8b9bc72 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3637,6 +3637,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  #ifdef CONFIG_X86_64
>  	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> +	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
>  #else
>  	loadsegment(fs, svm->host.fs);
>  #endif

Doesn't this also obsolete the wrmsrl(MSR_KERNEL_GS_BASE) in svm_vcpu_put?

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
