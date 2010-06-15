Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0FOMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0FOMJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:09:24 -0400
Message-ID: <4C176D71.7060302@redhat.com>
Date: Tue, 15 Jun 2010 15:09:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: MMU: trace pte prefetch
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E7F4.5060801@cn.fujitsu.com> <4C16E82E.5010306@cn.fujitsu.com> <4C16E867.8040606@cn.fujitsu.com> <4C16E9AF.2090501@cn.fujitsu.com>
In-Reply-To: <4C16E9AF.2090501@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 05:47 AM, Xiao Guangrong wrote:
> Trace pte prefetch to see what trouble we meet, if can help us to
> improve the prefetch
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c         |   12 +++++++++++-
>   arch/x86/kvm/mmutrace.h    |   26 ++++++++++++++++++++++++++
>   arch/x86/kvm/paging_tmpl.h |    9 ++++++++-
>   3 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 941c86b..0aaa18d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -91,6 +91,11 @@ module_param(oos_shadow, bool, 0644);
>
>   #define PTE_PREFETCH_NUM	16
>
> +#define PREFETCH_SUCCESS	0
> +#define PREFETCH_ERR_GFN2PFN	1
> +#define PREFETCH_ERR_ALLOC_MEM	2
> +#define PREFETCH_ERR_READ_GPTE	3
> +
>   #define PT_FIRST_AVAIL_BITS_SHIFT 9
>   #define PT64_SECOND_AVAIL_BITS_SHIFT 52
>
> @@ -2066,11 +2071,16 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
>   		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
>   		if (is_error_pfn(pfn)) {
>   			kvm_release_pfn_clean(pfn);
> +			trace_pte_prefetch(true, PREFETCH_ERR_GFN2PFN);
>   			break;
>   		}
>    

What about virtual addresses and gptes?  They can be helpful too.

-- 
error compiling committee.c: too many arguments to function

