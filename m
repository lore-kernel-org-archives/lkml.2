Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0JUREe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:04:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42357 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0JUREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:04:32 -0400
Date: Thu, 21 Oct 2010 11:04:29 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the devicetree tree
Message-ID: <20101021170429.GA16702@angua.secretlab.ca>
References: <20101021133726.d1e5f433.sfr@canb.auug.org.au>
 <20101021032657.GB13335@angua.secretlab.ca>
 <20101021080526.GB8775@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021080526.GB8775@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 10:05:26AM +0200, Ingo Molnar wrote:
> > On Thu, Oct 21, 2010 at 01:37:26PM +1100, Stephen Rothwell wrote:
> > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> > index 4417f49..23216f7 100644
> > --- a/arch/x86/kernel/irq.c
> > +++ b/arch/x86/kernel/irq.c
> > @@ -276,12 +276,14 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
> >  
> >  EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
> >  
> > +#ifdef CONFIG_OF
> >  unsigned int irq_create_of_mapping(struct device_node *controller,
> >                 const u32 *intspec, unsigned int intsize)
> >  {
> >         return intspec[0];
> >  }
> >  EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> > +#endif
> 
> Sigh, 'of' is the most misnamed Linux subsystem in history! 'CONFIG_OF_' always 
> makes me ask 'config of what?' irq_create_of_mapping ditto.
> 
> Why not OFW or OPENFIRMWARE?

That's not the half of it.  Most of the new platforms using this code
don't have openfirmware either.  This subsystem merely supports the
device tree data structure which originated with OpenFirmware, but has
been used heavily in non-ofw systems for many years now.  Something
like dt_* would be more accurate.

The of_ prefixes are entirely historical.  Off and on I consider doing
a mass rename, but I shy away from the scope of the work (plus nobody
has complained loud enough to make it a priority).  If I were to do
such a thing it would probably be best to use a script to handle all
the renames, and I'd want to organize with Linus to get it committed
when it will have the least impact on everyone.  Probably
immediately after a merge window closes.

BTW, I'm actually dropping the patch that added this function to x86
for this merge window since the patch that uses it isn't quite ready
yet.  It will sit in my test tree for another cycle.

g.
