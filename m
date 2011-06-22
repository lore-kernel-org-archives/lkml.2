Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab1FVUDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551Ab1FVUDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:03:33 -0400
Date: Wed, 22 Jun 2011 14:13:36 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/22] KVM: MMU: fix walking shadow page table
Message-ID: <20110622171336.GA24700@amt.cnet>
References: <4E01FBC9.3020009@cn.fujitsu.com>
 <4E01FBF4.9070004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E01FBF4.9070004@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:28:04PM +0800, Xiao Guangrong wrote:
> Properly check the last mapping, and do not walk to the next level if last spte
> is met
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 9c629b5..f474e93 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1517,10 +1517,6 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
>  	if (iterator->level < PT_PAGE_TABLE_LEVEL)
>  		return false;
>  
> -	if (iterator->level == PT_PAGE_TABLE_LEVEL)

Change to >= PT_PAGE_TABLE_LEVEL, checks should be in shadow_walk_okay.

> -		if (is_large_pte(*iterator->sptep))
> -			return false;
> -
>  	iterator->index = SHADOW_PT_INDEX(iterator->addr, iterator->level);
>  	iterator->sptep	= ((u64 *)__va(iterator->shadow_addr)) + iterator->index;
>  	return true;
