Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0G0Sco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:32:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0G0Scn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:32:43 -0400
Message-ID: <4C4F2643.8080507@redhat.com>
Date: Tue, 27 Jul 2010 21:32:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com> <1280247261-19115-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1280247261-19115-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/27/2010 07:14 PM, Joerg Roedel wrote:
> This patch implements the emulations of the svm next_rip
> feature in the nested svm implementation in kvm.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/kvm/svm.c |    8 +++++++-
>   1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7d10f2c..b44c9cc 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1919,6 +1919,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
>   	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
>   	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
>   	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
> +	nested_vmcb->control.next_rip          = vmcb->control.next_rip;
>

Can it be really this simple?  Suppose we emulate a nested guest 
instruction just before vmexit, doesn't that invalidate 
vmcb->control.next_rip?  Can that happen?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

