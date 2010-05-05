Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577Ab0EEMaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab0EEMaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:30:23 -0400
Message-ID: <4BE164D9.2030301@redhat.com>
Date: Wed, 05 May 2010 15:30:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM MMU: fix for forgot mark parent->unsync_children
 bit
References: <4BE16265.7060004@cn.fujitsu.com>
In-Reply-To: <4BE16265.7060004@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 03:19 PM, Xiao Guangrong wrote:
> When mapping a new parent to unsync shadow page, we should mark
> parent's unsync_children bit
>
> Reported-by: Marcelo Tosatti<mtosatti@redhat.com>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 97f2ea0..bf35a2f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1374,7 +1374,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   			if (sp->unsync_children) {
>   				set_bit(KVM_REQ_MMU_SYNC,&vcpu->requests);
>   				kvm_mmu_mark_parents_unsync(sp);
> -			}
> +			} else if (sp->unsync)
> +				kvm_mmu_mark_parents_unsync(sp);
> +
>   			trace_kvm_mmu_get_page(sp, false);
>   			return sp;
>   		}
>    


Which patch does this fix?  If it wasn't merge yet, please repost with 
the fix included.

-- 
error compiling committee.c: too many arguments to function

