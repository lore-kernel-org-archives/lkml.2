Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2DSSlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:41:23 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57209 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab2DSSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:41:21 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 14:41:21 EDT
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v6] irq: add irq_domain support to generic-chip
To: Thomas Abraham <thomas.abraham@linaro.org>,
        Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        b-cousson@ti.com, Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <CAJuYYwQ+1_i6ZVvJp-a3vpmNuqC7WWCMS6sDAEaMBHOUVwYrrw@mail.gmail.com>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com> <1328741722-1254-1-git-send-email-robherring2@gmail.com> <CAJuYYwQ+1_i6ZVvJp-a3vpmNuqC7WWCMS6sDAEaMBHOUVwYrrw@mail.gmail.com>
Date: Thu, 19 Apr 2012 12:34:20 -0600
Message-Id: <20120419183420.40BEC3E0700@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 10:53:33 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Hi Rob,
> 
> On 9 February 2012 04:25, Rob Herring <robherring2@gmail.com> wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> >
> > Add irq domain support to irq generic-chip. This enables users of
> > generic-chip to support dynamic irq assignment needed for DT interrupt
> > binding.
> >
> > Thanks to Shawn Guo for fixes and testing.
> >
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > ---
> > Here's the latest version. This has fixes from Shawn Guo, so should be
> > working. This version is also available here:
> >
> > git://sources.calxeda.com/kernel/linux.git pl061-domain-v6.
> >
> >  include/linux/irq.h       |   15 +++++
> >  kernel/irq/generic-chip.c |  152 ++++++++++++++++++++++++++++++++++++++-------
> >  2 files changed, 145 insertions(+), 22 deletions(-)
> >
> 
> [...]
> 
> > diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
> > index c89295a..3ac7fa1 100644
> > --- a/kernel/irq/generic-chip.c
> > +++ b/kernel/irq/generic-chip.c
> 
> [...]
> 
> > +static const struct irq_domain_ops irq_gc_irq_domain_ops = {
> > +       .map = irq_gc_irq_domain_map,
> > +       .xlate = irq_domain_xlate_onetwocell,
> > +};
> 
> Is there anyway to use a custom xlate function instead of the fixed
> 'irq_domain_xlate_onetwocell' xlate function. I am using this patchset
> with Exynos4 interrupt combiner controller whose interrupt specifier
> format is two cell but has different meaning. The first cell is the
> interrupt combiner number and the second cell is the interrupt number
> within that combiner.

I think it would be good to rework the API so that irq_domain +
generic_chip works like a library and setup helper function that
allows a driver to provide custom implementations for things like
xlate before the irqdomain and generic chips get registered.

g.

