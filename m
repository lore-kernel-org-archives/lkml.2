Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2ITKyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2ITKyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:54:35 -0400
Message-ID: <505AF5E7.6060805@redhat.com>
Date: Thu, 20 Sep 2012 13:54:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] KVM: MMU: cleanup FNAME(page_fault)
References: <5052FF61.3070600@linux.vnet.ibm.com> <5052FFC2.6060405@linux.vnet.ibm.com>
In-Reply-To: <5052FFC2.6060405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 12:58 PM, Xiao Guangrong wrote:
> Let it return emulate state instead of spte like __direct_map
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   28 ++++++++++------------------
>  1 files changed, 10 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 92f466c..0adf376 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -463,20 +463,18 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
>  /*
>   * Fetch a shadow pte for a specific level in the paging hierarchy.
>   */
> -static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
> +static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  			 struct guest_walker *gw,
>  			 int user_fault, int write_fault, int hlevel,
> -			 int *emulate, pfn_t pfn, bool map_writable,
> -			 bool prefault)
> +			 pfn_t pfn, bool map_writable, bool prefault)
>  {

Please document the return value in the comment.


-- 
error compiling committee.c: too many arguments to function
