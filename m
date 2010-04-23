Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab0DWNu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:50:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:58694 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464Ab0DWNuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:50:24 -0400
Subject: Re: [PATCH 3/8] KVM: SVM: Sync cr0 and cr3 to kvm state before nested handling
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1271932394-13968-4-git-send-email-joerg.roedel@amd.com>
Date: Fri, 23 Apr 2010 15:50:20 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <894CCCC7-6E35-499D-9EF6-57A9123B969C@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <1271932394-13968-4-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.04.2010, at 12:33, Joerg Roedel wrote:

> This patch syncs cr0 and cr3 from the vmcb to the kvm state
> before nested intercept handling is done. This allows to
> simplify the vmexit path.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
> arch/x86/kvm/svm.c |   15 ++++++---------
> 1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index c480d7f..5ad9d80 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1799,10 +1799,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
> 	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
> 	nested_vmcb->save.idtr   = vmcb->save.idtr;
> 	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
> -	if (npt_enabled)
> -		nested_vmcb->save.cr3    = vmcb->save.cr3;
> -	else
> -		nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;
> +	nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;


Why don't we need this anymore again?


Alex

