Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271Ab2DKViG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:38:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:45994 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987Ab2DKViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:38:04 -0400
Message-ID: <1334180248.2984.39.camel@pasglop>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Milton Miller <miltonm@bga.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 12 Apr 2012 07:37:28 +1000
In-Reply-To: <20120411205707.68AC13E08B6@localhost>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	 <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	 <20120402202848.1EB833E02A7@localhost>
	 <20120402215524.GM24211@n2100.arm.linux.org.uk>
	 <1333406005.30734.61.camel@pasglop>
	 <20120402225223.GN24211@n2100.arm.linux.org.uk>
	 <1333409927.30734.62.camel@pasglop> <m24nsx9iz1.fsf@igel.home>
	 <1333755470.3040.38.camel@pasglop> <m2aa2n7mmw.fsf@igel.home>
	 <1334106834.2984.17.camel@pasglop> <1334107996.2984.20.camel@pasglop>
	 <1334122182.2984.33.camel@pasglop> <20120411205707.68AC13E08B6@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 14:57 -0600, Grant Likely wrote:
> 
> Yeah, I've got a different way to fix it though.  There is exactly one
> user of irq_virq_count in-tree right now: PS3.  Also, irq_virq_count
> is only useful for the NOMAP mapping.  So, instead of having a single
> global irq_virq_count values, I've dropped it entirely and added a
> max_irq argument to irq_domain_add_nomap().  That makes it a property
> of an individual nomap irq domain instead of a global system settting.
> 
> Hopefully I'll have a draft patch ready today. 

That works for me. I'll send patches for cleanup MPIC as well.

One thing tho (Thomas, Russell) is that I like using set_irq_trigger to
establish the "defaults" in mpic, ie, it does the descriptor locking
etc... for me, I'd rather avoid open coding all of that. What I need is
a "variant" that doesn't actually change the trigger but instead
initializes the irq_desc with whatever settings the HW currently has
(ie, I need to make sure things are properly in sync) though other
implementations may want to use that for defaults.

Any objection to defining something like IRQ_TYPE_DEFAULT ?

I was thinking about making it equal to IRQ_TYPE_SENSE_MASK since that
can obviously not be a valid trigger value and is distinct from
IRQ_TYPE_NONE.

Cheers,
Ben.


