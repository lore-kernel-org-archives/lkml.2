Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab0GBRWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:22:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759437Ab0GBRWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:22:50 -0400
Date: Fri, 2 Jul 2010 13:47:56 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] KVM: MMU: introduce gfn_to_pfn_atomic() function
Message-ID: <20100702164756.GA25969@amt.cnet>
References: <4C2C9DC0.8050607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2C9DC0.8050607@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:53:04PM +0800, Xiao Guangrong wrote:
> Introduce gfn_to_pfn_atomic(), it's the fast path and can used in atomic
> context, the later patch will use it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/mm/gup.c        |    2 ++
>  include/linux/kvm_host.h |    1 +
>  virt/kvm/kvm_main.c      |   32 +++++++++++++++++++++++++-------
>  3 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index 738e659..0c9034b 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -6,6 +6,7 @@
>   */
>  #include <linux/sched.h>
>  #include <linux/mm.h>
> +#include <linux/module.h>
>  #include <linux/vmstat.h>
>  #include <linux/highmem.h>
>  
> @@ -274,6 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  
>  	return nr;
>  }
> +EXPORT_SYMBOL_GPL(__get_user_pages_fast);
>  
>  /**
>   * get_user_pages_fast() - pin user pages in memory

This should be a separate patch (overlooked that before). Ingo, Nick,
can this go in through the kvm tree?

