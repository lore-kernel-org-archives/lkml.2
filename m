Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1HVPX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:23:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab1HVPX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:23:26 -0400
Date: Mon, 22 Aug 2011 11:23:18 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110822152318.GC2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
 <1314022580.24275.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314022580.24275.33.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 04:16:20PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-08-19 at 16:37 -0400, Don Zickus wrote:
> > +static struct nmiaction *__free_nmi(unsigned int type, const char *name)
> > +{
> > +       struct nmi_desc *desc = nmi_to_desc(type);
> > +       struct nmiaction *n, **np = &(desc->head);
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&desc->lock, flags);
> > +
> ...
> > +
> > +       spin_unlock_irqrestore(&desc->lock, flags);
> > +       synchronize_rcu();
> > +       return *np;
> > +}
> 
> > +void unregister_nmi_handler(unsigned int type, const char *name)
> > +{
> > +       kfree(__free_nmi(type, name));
> > +}
> 
> This code is weird.. why not have the kfree() in __free_nmi(), also why
> use sync_rcu() and not use kfree_rcu()?

It's a mixture of copying the notifier code and not fully understanding
the rcu options out there.  I'll look into kfree_rcu and try to clean this
up.

> 
> > +EXPORT_SYMBOL_GPL(unregister_nmi_handler); 
> 
> *g*, so binary modules can register an NMI handler, but can't unregister
> it..?

heh.  I suck.  Sorry about that.

Cheers,
Don

