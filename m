Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264Ab2FEAbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:31:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:5468 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab2FEAbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:31:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151575756"
Message-ID: <1338856360.14538.220.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH v3 2/2] x86 mce: use new printk recursion disabling
 interface
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Tue, 05 Jun 2012 08:32:40 +0800
In-Reply-To: <20120604171202.GA8533@x1.osrc.amd.com>
References: <20120523100138.GA13506@x1.osrc.amd.com>
	 <4FBDCE4A.7050900@intel.com> <20120524061145.GA18284@liondog.tnic>
	 <20120524155611.b7aeff4d.akpm@linux-foundation.org>
	 <1337905811.14538.206.camel@ymzhang.sh.intel.com>
	 <4FBF3295.7090608@intel.com>
	 <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com>
	 <1338165058.14538.209.camel@ymzhang.sh.intel.com>
	 <4FC2E8CF.2040109@intel.com> <4FC2E944.6060903@intel.com>
	 <20120604171202.GA8533@x1.osrc.amd.com>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 19:12 +0200, Borislav Petkov wrote:
> On Mon, May 28, 2012 at 10:56:04AM +0800, ShuoX Liu wrote:
> > From: ShuoX Liu <shuox.liu@intel.com>
> > 
> > Disable printk recursion to make sure MCE logs printed out.
> > 
> > Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> > Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > index 2afcbd2..365c35d 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -1015,6 +1015,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
> >  	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
> >  	char *msg = "Unknown";
> >  
> > +	printk_recursion_check_disable();
> >  	atomic_inc(&mce_entry);
> >  
> >  	this_cpu_inc(mce_exception_count);
> > @@ -1144,6 +1145,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
> >  	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
> >  out:
> >  	atomic_dec(&mce_entry);
> > +	printk_recursion_check_enable();
> >  	sync_core();
> 
> This is still adding the recursion check things in do_machine_check
> instead of in print_mce.
Boris,

You are seeing an old patch. The new patches V4 are:
https://lkml.org/lkml/2012/6/3/176
https://lkml.org/lkml/2012/6/3/177


The new patches change mce_panic instead of do_machine_check.

> 
> Also, this commit message above needs more explanation why we want to
> disable the recursion check on an MCE, maybe an example...
V4 doesn't have the comment. We would add it in V5.

Thanks.


