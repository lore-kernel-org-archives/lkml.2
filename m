Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1FTR04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab1FTR0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:26:53 -0400
Date: Mon, 20 Jun 2011 13:28:06 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 02/15] KVM: MMU: do not update slot bitmap if spte is
 nonpresent
Message-ID: <20110620162806.GC17130@amt.cnet>
References: <4DEE205E.8000601@cn.fujitsu.com>
 <4DEE20AD.5060109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEE20AD.5060109@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 08:59:25PM +0800, Xiao Guangrong wrote:
> Set slot bitmap only if the spte is present
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index cda666a..125f78d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -743,9 +743,6 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
>  	struct kvm_mmu_page *sp;
>  	unsigned long *rmapp;
>  
> -	if (!is_rmap_spte(*spte))
> -		return 0;
> -

Not sure if this is safe, what if the spte is set as nonpresent but
rmap not removed?

BTW i don't see what patch 1 and this have to do with the goal
of the series.

