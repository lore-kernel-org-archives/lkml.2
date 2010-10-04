Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0JDUjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:39:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab0JDUjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:39:54 -0400
Date: Mon, 4 Oct 2010 16:39:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Drake <dsd@laptop.org>, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: Dynamic nop selection breaks boot on Geode LX
Message-ID: <20101004203921.GG2900@redhat.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com> <20101004154633.GA2900@redhat.com> <1286224272.6750.70.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286224272.6750.70.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 04:31:12PM -0400, Steven Rostedt wrote:
> On Mon, 2010-10-04 at 11:46 -0400, Jason Baron wrote:
> 
> >  	restart_nmi();
> > +
> > +	local_irq_save(flags);
> > +	arch_init_ideal_nop5();
> > +	local_irq_restore(flags);
> >  }
> >  
> >  /**
> 
> BTW, why the irq disabling around the call?
> 
> -- Steve
> 
> 

Only b/c the selection of the nop was originally done by
'ftrace_dyn_arch_init()' which had irq's disabled around it. So maybe
that can be dropped now?

thanks,

-Jason
