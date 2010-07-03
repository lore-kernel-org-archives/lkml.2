Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0GCDNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 23:13:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:51597 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0GCDNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 23:13:09 -0400
Date: Sat, 3 Jul 2010 13:13:02 +1000
From: Nick Piggin <npiggin@suse.de>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] KVM: MMU: introduce gfn_to_pfn_atomic() function
Message-ID: <20100703031302.GD11732@laptop>
References: <4C2C9DC0.8050607@cn.fujitsu.com>
 <20100702164756.GA25969@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702164756.GA25969@amt.cnet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 01:47:56PM -0300, Marcelo Tosatti wrote:
> On Thu, Jul 01, 2010 at 09:53:04PM +0800, Xiao Guangrong wrote:
> > Introduce gfn_to_pfn_atomic(), it's the fast path and can used in atomic
> > context, the later patch will use it
> > 
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > ---
> >  arch/x86/mm/gup.c        |    2 ++
> >  include/linux/kvm_host.h |    1 +
> >  virt/kvm/kvm_main.c      |   32 +++++++++++++++++++++++++-------
> >  3 files changed, 28 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> > index 738e659..0c9034b 100644
> > --- a/arch/x86/mm/gup.c
> > +++ b/arch/x86/mm/gup.c
> > @@ -6,6 +6,7 @@
> >   */
> >  #include <linux/sched.h>
> >  #include <linux/mm.h>
> > +#include <linux/module.h>
> >  #include <linux/vmstat.h>
> >  #include <linux/highmem.h>
> >  
> > @@ -274,6 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
> >  
> >  	return nr;
> >  }
> > +EXPORT_SYMBOL_GPL(__get_user_pages_fast);
> >  
> >  /**
> >   * get_user_pages_fast() - pin user pages in memory
> 
> This should be a separate patch (overlooked that before). Ingo, Nick,
> can this go in through the kvm tree?

I'm happy for it to be exported. Yes put it in a seperate patch and
add an acked-by: me on it please. Beyond that I don't care what tree
it goes through :) although Ingo might have an opinion


