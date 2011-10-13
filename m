Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1JMOAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab1JMOAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:00:12 -0400
Date: Thu, 13 Oct 2011 09:59:47 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V4 10/10] jump-label: initialize jump-label subsystem
 much earlier
Message-ID: <20111013135945.GB2455@redhat.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
 <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com>
 <1318502628.24856.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318502628.24856.10.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 12:43:48PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-10-12 at 17:08 -0700, Jeremy Fitzhardinge wrote:
> > From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > 
> > Initialize jump_labels much earlier, we can use them.
> 
> We can use them, where? how? what?, that sentence just begs for more.
> 
> > diff --git a/init/main.c b/init/main.c
> > index 2a9b88a..f4094ed 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -637,6 +637,7 @@ asmlinkage void __init start_kernel(void)
> >  	acpi_early_init(); /* before LAPIC and SMP init */
> >  	sfi_init_late();
> >  
> > +	jump_label_init();
> >  	ftrace_init();
> >  
> >  	/* Do the rest non-__init'ed, we're now alive */
> 
> Can we push them much earlier still? If possible I'd like them to be
> before sched_init() so that I might use them there, if not possible, at
> the very least before enabling interrupts would be nice.
> 
> 

Yes, earlier still would be good. Also, it still bothers me a bit that
jump_label_inc()/dec() could be called and the branch not updated until
the jump label initialization. I feel like there should be a WARN() for
this case...ie:

jump_label_inc()/dec() {
	if (!jump_label_initialized)
		WARN("calling branch update before subsystem initialization");
}





