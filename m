Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1AGOn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:43:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1AGOn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:43:27 -0500
Date: Fri, 7 Jan 2011 09:43:18 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Robert Richter <robert.richter@amd.com>,
        ying.huang@intel.com, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] x86, NMI: Add priorities to handlers
Message-ID: <20110107144318.GU2317@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
 <1294348732-15030-4-git-send-email-dzickus@redhat.com>
 <1294405791.2016.450.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294405791.2016.450.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:09:51PM +0100, Peter Zijlstra wrote:
> >  static struct event_constraint unconstrained;
> > diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> > index cd21b65..983fb54 100644
> > --- a/arch/x86/kernel/kgdb.c
> > +++ b/arch/x86/kernel/kgdb.c
> > @@ -606,7 +606,7 @@ static struct notifier_block kgdb_notifier = {
> >  	/*
> >  	 * Lowest-prio notifier priority, we want to be notified last:
> >  	 */
> > -	.priority	= -INT_MAX,
> > +	.priority	= NMI_LOCAL_LOW_PRIOR,
> >  };
> >  
> >  /**
> 
> 
> I had to add the below to make things build here.
> 
> ---
> Index: linux-2.6/arch/x86/kernel/kgdb.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/kgdb.c
> +++ linux-2.6/arch/x86/kernel/kgdb.c
> @@ -48,6 +48,7 @@
>  #include <asm/apicdef.h>
>  #include <asm/system.h>
>  #include <asm/apic.h>
> +#include <asm/nmi.h>
>  
>  struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
>  {
> 

Doh.  I missed a spot.  Thanks for the catch.  I'll add that and repost.

Cheers,
Don
