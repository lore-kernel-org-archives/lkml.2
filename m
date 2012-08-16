Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030211Ab2HPTad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:30:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41182 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2HPTaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:30:30 -0400
Date: Thu, 16 Aug 2012 16:30:21 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [v2.6.34-stable 016/165] KVM: Ensure all vcpus are consistent
 with in-kernel irqchip settings
Message-ID: <20120816193017.GA17364@herton-Z68MA-D2H-B3>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
 <1345060109-9187-17-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345060109-9187-17-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:46:00PM -0400, Paul Gortmaker wrote:
> From: Avi Kivity <avi@redhat.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
[...]
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c82ae24..559af38 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1322,6 +1322,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  		return r;
>  
>  	mutex_lock(&kvm->lock);
> +	if (!kvm_vcpu_compatible(vcpu)) {
> +		r = -EINVAL;
> +		goto unlock_vcpu_destroy;
> +	}
>  	if (atomic_read(&kvm->online_vcpus) == KVM_MAX_VCPUS) {
>  		r = -EINVAL;
>  		goto vcpu_destroy;

Fails to build:

linux-stable/arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_vm_ioctl_create_vcpu':
linux-stable/arch/x86/kvm/../../../virt/kvm/kvm_main.c:1327: error: label 'unlock_vcpu_destroy' used but not defined

Looking at it, vcpu_destroy would be label name to be used instead.

-- 
[]'s
Herton
