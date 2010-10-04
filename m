Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0JDWLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:11:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab0JDWLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:11:03 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=YGL2JzEyuHAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ASFZG9o2GaUVeqMjKpwA:9 a=5rnckDwLwzkjo8AuBWqDDK9aUHMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Dynamic nop selection breaks boot on Geode LX
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Daniel Drake <dsd@laptop.org>, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
In-Reply-To: <20101004203921.GG2900@redhat.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
	 <20101004154633.GA2900@redhat.com>
	 <1286224272.6750.70.camel@gandalf.stny.rr.com>
	 <20101004203921.GG2900@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 04 Oct 2010 18:11:00 -0400
Message-ID: <1286230260.6750.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 16:39 -0400, Jason Baron wrote:
> On Mon, Oct 04, 2010 at 04:31:12PM -0400, Steven Rostedt wrote:
> > On Mon, 2010-10-04 at 11:46 -0400, Jason Baron wrote:
> > 
> > >  	restart_nmi();
> > > +
> > > +	local_irq_save(flags);
> > > +	arch_init_ideal_nop5();
> > > +	local_irq_restore(flags);
> > >  }
> > >  
> > >  /**
> > 
> > BTW, why the irq disabling around the call?
> > 
> > -- Steve
> > 
> > 
> 
> Only b/c the selection of the nop was originally done by
> 'ftrace_dyn_arch_init()' which had irq's disabled around it. So maybe
> that can be dropped now?

Yeah, that disable is there for legacy reasons. It can be scrapped.

I'll remove it.

Thanks!

-- Steve


