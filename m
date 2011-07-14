Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1GNKNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 06:13:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1GNKNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 06:13:15 -0400
Message-ID: <4E1EC133.8030109@redhat.com>
Date: Thu, 14 Jul 2011 13:13:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/7] KVM: SVM: Keep seperate pointer to host-vmcb
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1310571145-28930-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2011 06:32 PM, Joerg Roedel wrote:
> From: Joerg Roedel<joro@8bytes.org>
>
> This patch introduces a new pointer which always points to
> the VMCB used for running the L1 guest.
>
> Signed-off-by: Joerg Roedel<joro@8bytes.org>
> ---
>   arch/x86/kvm/svm.c |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 475d1c9..3d5990f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -113,7 +113,9 @@ static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>   struct vcpu_svm {
>   	struct kvm_vcpu vcpu;
>   	struct vmcb *vmcb;
> +	struct vmcb *host_vmcb;
>   	unsigned long vmcb_pa;
> +	unsigned long host_vmcb_pa;

Why not call it vmcb01, like nvmx?  host_vmcb is ambiguous.

-- 
error compiling committee.c: too many arguments to function

