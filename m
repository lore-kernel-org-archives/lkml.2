Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335Ab0EEOrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0EEOrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:47:02 -0400
Message-ID: <4BE184E3.1010508@redhat.com>
Date: Wed, 05 May 2010 17:46:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: SVM: Allow EFER.LMSLE to be set with nested
 svm
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com> <1273068285-3105-5-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1273068285-3105-5-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 05:04 PM, Joerg Roedel wrote:
> This patch enables setting of efer bit 13 which is allowed
> in all SVM capable processors. This is necessary for the
> SLES11 version of Xen 4.0 to boot with nested svm.
>    

Interesting, why does it require it?

Obviously it isn't needed since it manages to run on Intel without it.

>   /* Intel MSRs. Some also available on other CPUs */
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 74f7b9d..bc087c7 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -610,7 +610,7 @@ static __init int svm_hardware_setup(void)
>
>   	if (nested) {
>   		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
> -		kvm_enable_efer_bits(EFER_SVME);
> +		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>   	}
>
>   	for_each_possible_cpu(cpu) {
>    

What if the host doesn't have it?

Why enable it only for the nested case?  It's not svm specific (it's 
useful for running non-hvm Xen in non-nested mode).

Isn't there a cpuid bit for it?  If so, it should be exposed to 
userspace, and the feature should depend on it.

-- 
error compiling committee.c: too many arguments to function

