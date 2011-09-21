Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab1IUN5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1IUN5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:57:24 -0400
Date: Wed, 21 Sep 2011 09:56:33 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110921135633.GN5795@redhat.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-3-git-send-email-dzickus@redhat.com>
 <4E7977DE.10009@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7977DE.10009@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 01:36:30PM +0800, Huang Ying wrote:
> On 09/20/2011 10:43 PM, Don Zickus wrote:
> > index 68d758a..c2df58a 100644
> > --- a/arch/x86/kernel/nmi.c
> > +++ b/arch/x86/kernel/nmi.c
> > @@ -13,6 +13,9 @@
> >  #include <linux/kprobes.h>
> >  #include <linux/kdebug.h>
> >  #include <linux/nmi.h>
> > +#include <linux/delay.h>
> > +#include <linux/hardirq.h>
> > +#include <linux/slab.h>
> >  
> >  #if defined(CONFIG_EDAC)
> >  #include <linux/edac.h>
> > @@ -21,6 +24,28 @@
> >  #include <linux/atomic.h>
> >  #include <asm/traps.h>
> >  #include <asm/mach_traps.h>
> > +#include <asm/nmi.h>
> > +
> > +#define NMI_MAX_NAMELEN	16
> > +struct nmiaction {
> > +	struct nmiaction __rcu *next;
> 
> Why not just use struct list_head here and use list_xxx_rcu family to
> operate on the list?  IMHO, that will make code simpler without much
> overhead.

Yeah, I just copied and pasted from what was in the notifier chain stuff.
Even though I don't need the previous pointer, the awkward rcu pointer
stuff would be a lot simpler to implement and read with those macros.  Let
me play with it and see what I come up with.

Thanks for the suggestion.

Cheers,
Don
