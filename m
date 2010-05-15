Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab0EOIHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 04:07:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab0EOIHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 04:07:38 -0400
Message-ID: <4BEE561E.5020607@redhat.com>
Date: Sat, 15 May 2010 11:06:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86: Use FPU API
References: <1273807013-4792-1-git-send-email-sheng@linux.intel.com> <1273807013-4792-4-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1273807013-4792-4-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 06:16 AM, Sheng Yang wrote:
> Convert KVM to use generic FPU API.
>
> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |   18 +---------
>   arch/x86/kvm/x86.c              |   73 ++++++++++++---------------------------
>   2 files changed, 23 insertions(+), 68 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ed48904..beba6f5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -300,8 +300,7 @@ struct kvm_vcpu_arch {
>   		unsigned long mmu_seq;
>   	} update_pte;
>
> -	struct i387_fxsave_struct host_fx_image;
> -	struct i387_fxsave_struct guest_fx_image;
> +	struct fpu host_fpu, guest_fpu;
>
>    

Do we really need host_fpu?  I think we can call unlazy_fpu() instead 
and drop host_fpu completely.  This might reduce the need for changes in 
patch 1 (as well as generally improving the code).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

