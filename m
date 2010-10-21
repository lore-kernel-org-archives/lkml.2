Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab0JUDyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 23:54:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47582 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab0JUDyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 23:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CmLZnNBlkT5SsdHHi6aSQtIH6vel8zKWIsGb2puCG6JuWIDViap7Edj6qk+WYNsm4C
         vI3+eTlxMmvgKb/1RLEUEQnulyuxaliSMr82hOqeACUWe3kNMcOX/KMh4A7yIzcwdZRv
         y6VNkHA81lNpEHUf/Ufa6Jzw/SbEL16fYU8+o=
Date: Thu, 21 Oct 2010 05:54:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] tracing: Prevent unloadable modules from using
	trace_bprintk()
Message-ID: <20101021035444.GH5387@nowhere>
References: <20101021024233.530237054@goodmis.org> <20101021024304.827826848@goodmis.org> <20101021034255.GG5387@nowhere> <1287632876.16971.561.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287632876.16971.561.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 11:47:56PM -0400, Steven Rostedt wrote:
> On Thu, 2010-10-21 at 05:42 +0200, Frederic Weisbecker wrote:
> 
> > > +/*
> > > + * Module code must not use trace_bprintk, because if it is unloaded
> > > + * then we leave a pointer back to the module code inside
> > > + * the ring buffer, and then reading the ring buffer may cause a bug.
> > > + *
> > > + * We do allow for modules to use it if the kernel does not allow
> > > + * unloading of modules, and MODVERSIONS is set (to make sure kernel
> > > + * and module are the same). If you load modules without MODVERSIONS
> > > + * set, then you deserve what you get.
> > > + */
> > > +#if defined(MODULE) &&							\
> > 
> > 
> > 
> > Did you mean CONFIG_MODULE may be?
> 
> Nope, then the a kernel that allows modules wont use it. I do mean
> "MODULE", as in defined by the Makefile:
> 
> KBUILD_AFLAGS_MODULE  := -DMODULE
> KBUILD_CFLAGS_MODULE  := -DMODULE


Ah ok.

Thanks.

