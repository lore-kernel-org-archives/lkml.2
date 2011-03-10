Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1CJVSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:18:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab1CJVSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:18:37 -0500
Date: Thu, 10 Mar 2011 16:18:01 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jump label: introduce static_branch() interface
Message-ID: <20110310211801.GB4058@redhat.com>
References: <cover.1299702291.git.jbaron@redhat.com>
 <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
 <1299790895.15854.419.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299790895.15854.419.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:01:35PM -0500, Steven Rostedt wrote:
> On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:
> 
> > diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> > index 961b6b3..dfa4c3c 100644
> > --- a/arch/x86/kernel/jump_label.c
> > +++ b/arch/x86/kernel/jump_label.c
> > @@ -4,13 +4,13 @@
> >   * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
> >   *
> >   */
> > -#include <linux/jump_label.h>
> >  #include <linux/memory.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/module.h>
> >  #include <linux/list.h>
> >  #include <linux/jhash.h>
> >  #include <linux/cpu.h>
> > +#include <linux/jump_label.h>
> >  #include <asm/kprobes.h>
> >  #include <asm/alternative.h>
> >  
> > diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> 
> Jason,
> 
> I'm curious, is there a reason for this header change? Clean up? Maybe
> it could go into a separate patch. If anything, just to make this one
> slightly smaller.
> 

hmm...I did that to get types.h for the new atomic_t usage.

However, now that I look at it again its bogus. The right fix is to
explicitly include <linux/types.h> from jump_label.h.

-Jason
