Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab2BOJcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:32:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63827 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2BOJcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:32:09 -0500
Date: Wed, 15 Feb 2012 01:32:04 -0800
From: Steven Noonan <steven@uplinklabs.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ben Guthro <ben@guthro.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
Message-ID: <20120215093204.GA17286@asmodeus>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
 <1328894901.25989.20.camel@laptop>
 <20120210190412.GB12975@phenom.dumpdata.com>
 <CAOvdn6WcdrLHOPJc0Hv53+0trEFnU=RQJL5+xUMhAO3C3HWqbw@mail.gmail.com>
 <20120212205016.GA2794@asmodeus>
 <20120215085737.GA13722@asmodeus>
 <1329297944.2293.36.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1329297944.2293.36.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 10:25:44AM +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-15 at 00:57 -0800, Steven Noonan wrote:
> > It seems to me that there are two options for fixing this, but I'm
> > probably lacking the necessary context (or experience with Xen). Either:
> > 
> > - The patch provided by Ben needs to have additional work to specially
> >   handle IRQ_WORK_VECTOR, since it seems to be a special case where
> >   there's no event channel attached for it. Perhaps adding an event
> >   channel for this is the fix? Seems high-overhead, but I lack a good
> >   understanding of how interrupts are handled in Xen.
> 
> So that's a self-IPI, is Xen failing to implement this?

Yes.

Ben's patch implements it, but it explodes (NULL pointer dereference)
when it can't find an event channel for IRQ_WORK_VECTOR.

> 
> > or
> > 
> > - Perf needs to be "enlightened" about Xen and avoid sending an IPI in
> >   the first place.
> 
> Uhm, no. If anything Xen should simply not implement
> arch_irq_work_raise(). The callbacks are then ran from the timer
> interrupt.

Sorry, wild guess. I'm a kernel newbie. :)
