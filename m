Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0KNJue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 04:50:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0KNJuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 04:50:32 -0500
Date: Sun, 14 Nov 2010 10:50:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@queued.net>
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v2)
Message-ID: <20101114095013.GB24206@elte.hu>
References: <20101111214546.4e573cad@queued.net>
 <reply-olpc-3-v2@mdm.bga.com>
 <20101112002704.50c629e2@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112002704.50c629e2@queued.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andres Salomon <dilinger@queued.net> wrote:

> On Fri, 12 Nov 2010 01:48:30 -0600
> Milton Miller <miltonm@bga.com> wrote:
> 
> > On Thu, 11 Nov 2010 around 21:45:46 -0800, Andres Salomon wrote:
> > > diff --git a/arch/x86/platform/olpc/olpc_dt.c
> > > b/arch/x86/platform/olpc/olpc_dt.c index b8c8ff9..0ab824d 100644
> > > --- a/arch/x86/platform/olpc/olpc_dt.c
> > > +++ b/arch/x86/platform/olpc/olpc_dt.c
> > > @@ -126,14 +126,31 @@  static unsigned int prom_early_allocated
> > > __initdata; 
> > >  void * __init prom_early_alloc(unsigned long size)
> > >  {
> > > +	static u8 *mem = NULL;
> > > +	static size_t free_mem = 0;
> > 
> > Static variables are implicitly 0 and NULL
> 
> That's true for global static variables; is it also true for static
> variables that are local to a function?

It is the same allocation and initialization wise - just not visible to functions 
outside this one.

It's being frowned upon btw, because it's easy to overlook (and for other reasons) - 
please dont use statics inside functions - please put them in front of the function 
or further up into file scope.

	Ingo
