Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0KDKf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:35:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab0KDKfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:35:54 -0400
Date: Thu, 4 Nov 2010 12:35:48 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
Message-ID: <20101104103548.GE6018@redhat.com>
References: <4CD28B5F.1040205@cn.fujitsu.com>
 <4CD28BCA.1060907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD28BCA.1060907@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 06:32:42PM +0800, Xiao Guangrong wrote:
> nonpaing guest's 'direct_map' is also true, retry #PF for those
> guests is useless, so use 'tdp_enabled' instead
> 
nonpaging guest will not attempt async pf. And by checking tdp_enabled
here instead of direct_map we will screw nested ntp.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/x86.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2044302..aacc5eb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6174,7 +6174,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>  	int r;
>  
> -	if (!vcpu->arch.mmu.direct_map || is_error_page(work->page))
> +	if (!tdp_enabled || is_error_page(work->page))
>  		return;
>  
>  	r = kvm_mmu_reload(vcpu);
> -- 
> 1.7.0.4

--
			Gleb.
