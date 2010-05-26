Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab0EZA2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:28:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:43794 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282Ab0EZA22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:28:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,300,1272870000"; 
   d="scan'208";a="281340138"
Subject: Re: [PATCH] x86/pat: fix memory leak in free_memtype
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <1274832742.2892.549.camel@sbs-t61.sc.intel.com>
References: <1274781156-2861-1-git-send-email-dfeng@redhat.com>
	 <1274832742.2892.549.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 25 May 2010 17:27:32 -0700
Message-Id: <1274833652.2892.579.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 17:12 -0700, Suresh Siddha wrote:
> On Tue, 2010-05-25 at 02:52 -0700, Xiaotian Feng wrote:
> > reserve_memtype will allocate memory for new memtype, but
> > in free_memtype, after the memtype erased from rbtree, the
> > memory is not freed.
> > 
> > Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Cc: Jack Steiner <steiner@sgi.com>
> > Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> >  arch/x86/mm/pat_rbtree.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
> > index 07de4cb..fb8c1e5 100644
> > --- a/arch/x86/mm/pat_rbtree.c
> > +++ b/arch/x86/mm/pat_rbtree.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/rbtree.h>
> >  #include <linux/sched.h>
> >  #include <linux/gfp.h>
> > +#include <linux/slab.h>
> >  
> >  #include <asm/pgtable.h>
> >  #include <asm/pat.h>
> > @@ -240,6 +241,7 @@ int rbt_memtype_erase(u64 start, u64 end)
> >  		return -EINVAL;
> >  
> >  	rb_erase(&data->rb, &memtype_rbroot);
> > +	kfree(data);
> >  	return 0;
> >  }
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> Peter, Please apply this for x86/urgent, this is introduced in the post
> 2.6.34 changes.

Xiaotian, Also I think more cleaner fix is to do this in free_memtype().
Can you please resend the patch with this change?

thanks,
suresh

