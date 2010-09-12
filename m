Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0ILRBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 13:01:52 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47239 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752942Ab0ILRBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 13:01:50 -0400
Date: Sun, 12 Sep 2010 08:46:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100912064612.GA1582@ucw.cz>
References: <4C84B088.5050003@redhat.com>
 <1283772256.1930.303.camel@laptop>
 <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100906154737.GA4332@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >>Is this a roundabout way of saying "jit"?
> > >Partly. I'm not sure we want to actually upload programs in bytecode
> > >form. ASCII is just fine - just like a .gz Javascript is fine for web
> > >apps. (and in most cases compresses down better than the bytecode
> > >equivalent)
> > >
> > >So a clear language (the simpler initially the better) plus an in-kernel
> > >compiler.
> > >
> > >This could be used for far more than just instrumentation: IMO security
> > >policies could be expressed in such a way. (Simplified, they are quite
> > >similar to filters installed on syscall entry/exit, with the ability of
> > >the filter to influence whether the syscall is performed.)
> > 
> > For me the requirements are:
> > - turing complete (more than just filters)
> 
> Yep. Filters are obviously just basically expressions.
> 
> Conditions and variables can be added. Maybe loops too in simpler forms 
> - as long as we can prove halting - or maybe with a runtime abort 
> mechanism.
> 
> > - easy interface to kernel APIs (like hrtimers)
> > - safe to use by untrusted users
> 
> Yep.
> 
> > The actual language doesn't really matter.
> 
> There are 3 basic categories:
> 
>  1- Most (least abstract) specific code: a block of bytecode in the form 
>     of a simplified, executable, kernel-checked x86 machine code block - 
>     this is also the fastest form. [yes, this is actually possible.]

Well... if we want to be a bit x86-entric.... can we just reuse ACPI
interpretter?

Plus, TOMOYO actually has a language inside... AppArmor actually has
something, too, but iirc it is only as powerful as regexps.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
