Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2FRDpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 23:45:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2FRDpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 23:45:44 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] irqdomain: Support one-shot tear down of domain mappings.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120615223403.GB7357@linux-sh.org>
References: <1339572841-26175-1-git-send-email-lethal@linux-sh.org> <1339572841-26175-2-git-send-email-lethal@linux-sh.org> <20120615183518.514853E0ACE@localhost> <20120615223403.GB7357@linux-sh.org>
Date: Sun, 17 Jun 2012 17:48:33 -0600
Message-Id: <20120617234833.32D303E086D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2012 07:34:03 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> On Fri, Jun 15, 2012 at 12:35:18PM -0600, Grant Likely wrote:
> > On Wed, 13 Jun 2012 16:34:01 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> > > +/**
> > > + * irq_domain_dispose_mappings() - Dispose of all mappings in a domain
> > > + * @domain: domain to tear down
> > > + */
> > > +void irq_domain_dispose_mappings(struct irq_domain *domain)
> > > +{
> > > +	if (domain->revmap_type == IRQ_DOMAIN_MAP_NOMAP)
> > > +		return;
> > > +
> > > +	if (domain->linear_size) {
> > > +		int i;
> > > +
> > > +		for (i = 0; i < domain->linear_size; i++)
> > > +			irq_dispose_mapping(domain->linear_revmap[i]);
> > > +	} else {
> > 
> > The 'else' should be dropped I think.  With the merge of linear and
> > tree mappings into the same domain type, it is possible for a domain
> > to have both linear and tree mappings in the same instance.  So tree
> > needs to be cleared even if linear_size is non-zero.
> > 
> Ok, that's fine. Though by that same logic wouldn't it also be possible
> for a domain to have multiple linear ranges?

except that there is only one linear map.  It would be possible to
have multiple maps, but I'm going to resist adding a whole lot of
options for reverse mapping to keep the lookup overhead low.  A
sufficiently large linear map would also handle multiple linear maps.

g.

