Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0EQJiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab0EQJiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:38:16 -0400
Message-ID: <4BF10E59.1090200@redhat.com>
Date: Mon, 17 May 2010 12:37:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2 3/3] KVM: x86: Use FPU API
References: <1274087308-26676-1-git-send-email-sheng@linux.intel.com> <1274087308-26676-4-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1274087308-26676-4-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 12:08 PM, Sheng Yang wrote:
> Convert KVM to use generic FPU API.
>
>   void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>   {
>   	if (vcpu->guest_fpu_loaded)
> @@ -5156,7 +5134,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>
>   	vcpu->guest_fpu_loaded = 1;
>   	unlazy_fpu(current);
> -	kvm_fx_restore(&vcpu->arch.guest_fx_image);
> +	fpu_restore_checking(&vcpu->arch.guest_fpu);
>   	trace_kvm_fpu(1);
>   }
>    

Do we need to do something on error here?

I think an error can only occur if userspace sets bad fpu state, so 
maybe do the check in the ioctl.

In any case, unrelated to this patch.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

