Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1HVPWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:22:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab1HVPWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:22:07 -0400
Date: Mon, 22 Aug 2011 11:21:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110822152154.GB2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
 <1314022429.24275.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314022429.24275.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 04:13:49PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-08-19 at 16:37 -0400, Don Zickus wrote:
> > +int register_nmi_handler(unsigned int type, nmi_handler_t handler,
> > +                       unsigned long nmiflags, const char *devname)
> > +{
> > +       struct nmiaction *action;
> > +       int retval;
> > +
> > +       if (!handler)
> > +               return -EINVAL;
> > +
> > +       action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
> > +       if (!action)
> > +               return -ENOMEM;
> > +
> > +       action->handler = handler;
> > +       action->flags = nmiflags;
> > +       action->name = devname; 
> 
> So you assume the string passed as devname remains stable..

yeah, I just kinda copied the irq stuff, thinking if it works there, it
should work here.  It does seem odd, but I can change that to strncpy to
be safer.

> 
> 
> > +
> > +       retval = __setup_nmi(type, action);
> > +
> > +       if (retval)
> > +               kfree(action);
> > +       
> > +       return retval;
> > +}
> > +EXPORT_SYMBOL(register_nmi_handler);
> 
> Also, I'd use _GPL, the current register_die_notifier() is also.
> Preferably I'd not export NMI stuff at all.

Sure.  Well there are a few drivers that want to register.  Unless you
want to make a rule that all nmi handlers have to be built-in?

Cheers,
Don
