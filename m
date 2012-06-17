Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2FQV6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:58:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60141 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab2FQV6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:58:41 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/12] irqdomain: Eliminate dedicated radix lookup functions
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <CACxGe6vv5v6oDrJp6u9kJ0TrBUU0ZKNQ-88E_+Cp1k7ifMACsQ@mail.gmail.com>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca> <1339822897-15840-5-git-send-email-grant.likely@secretlab.ca> <1339826183.9220.218.camel@pasglop> <CACxGe6vv5v6oDrJp6u9kJ0TrBUU0ZKNQ-88E_+Cp1k7ifMACsQ@mail.gmail.com>
Date: Sun, 17 Jun 2012 15:58:39 -0600
Message-Id: <20120617215839.3643F3E05C0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2012 00:12:45 -0600, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Jun 15, 2012 at 11:56 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
> >> @@ -329,9 +329,6 @@ static int xics_host_map(struct irq_domain *h, unsigned int virq,
> >>
> >>       pr_devel("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
> >>
> >> -     /* Insert the interrupt mapping into the radix tree for fast lookup */
> >> -     irq_radix_revmap_insert(xics_host, virq, hw);
> >> -
> >>       /* They aren't all level sensitive but we just don't really know */
> >>       irq_set_status_flags(virq, IRQ_LEVEL);
> >
> > This looks like it belongs in a different patch, possibly "[02/12]
> > irqdomain: Always update revmap when setting up a virq" no ?
[...]
> >> @@ -415,7 +415,9 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
> >>                               domain->revmap_data.linear.revmap[hwirq] = virq;
> >>                       break;
> >>               case IRQ_DOMAIN_MAP_TREE:
> >> -                     irq_radix_revmap_insert(domain, virq, hwirq);
> >> +                     mutex_lock(&revmap_trees_mutex);
> >> +                     radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
> >> +                     mutex_unlock(&revmap_trees_mutex);
> >>                       break;
> >>               }
> >
> > That too looks like it belongs in another patch.
> 
> Okay, I'll take a look at those.

Both moved to patch 2.

g.
