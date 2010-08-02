Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0HBPSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:18:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0HBPSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:18:13 -0400
Message-ID: <4C56E1B1.4070805@redhat.com>
Date: Mon, 02 Aug 2010 18:18:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Check for nested vmrun intercept before
 emulating vmrun
References: <1280760405-22591-1-git-send-email-joerg.roedel@amd.com> <1280760405-22591-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1280760405-22591-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/02/2010 05:46 PM, Joerg Roedel wrote:
> This patch lets the nested vmrun fail if the L1 hypervisor
> has not intercepted vmrun. This fixes the "vmrun intercept
> check" unit test.

> +
>   static bool nested_svm_vmrun(struct vcpu_svm *svm)
>   {
>   	struct vmcb *nested_vmcb;
> @@ -2029,6 +2037,17 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>   	if (!nested_vmcb)
>   		return false;
>
> +	if (!nested_vmcb_checks(nested_vmcb)) {
> +		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
> +		nested_vmcb->control.exit_code_hi = 0;
> +		nested_vmcb->control.exit_info_1  = 0;
> +		nested_vmcb->control.exit_info_2  = 0;
> +
> +		nested_svm_unmap(page);
> +
> +		return false;
> +	}
> +

Don't you have to transfer an injected event to exitintinfo?

-- 
error compiling committee.c: too many arguments to function

