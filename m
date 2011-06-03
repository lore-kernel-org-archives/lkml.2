Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1FCQZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:25:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:60664 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1FCQZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:25:04 -0400
Date: Fri, 3 Jun 2011 18:25:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Milton Miller <miltonm@bga.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
In-Reply-To: <locate-from-more@mdm.bga.com>
Message-ID: <alpine.LFD.2.02.1106031823310.3078@ionos>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com> <nack-locate@mdm.bga.com> <20110603104217.GA4777@opensource.wolfsonmicro.com> <locate-from-more@mdm.bga.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011, Milton Miller wrote:

> On Fri, 3 Jun 2011 about 11:42:17 +0100, Mark Brown wrote:
> > On Fri, Jun 03, 2011 at 04:24:02AM -0500, Milton Miller wrote:
> > > On Thu, 02 Jun 2011 17:55:13 -0000, Mark Brown wrote:
> > 
> > > >  	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
> > 
> > > and then right after this the code continues:
> > 
> > >         ret = -EEXIST;
> > >         if (irq >=0 && start != irq)
> > >                 goto err;
> > 
> > > This patch enables exactly the calls I want to forbid !  Why do
> > 
> > Which you wish to forbid because...?  You've not articulated any
> > motivation for doing this which makes it rather hard to engage here.
> 
> In 2.6.39 all calls to irq_alloc_descs were from the helpers.  Either
> from  irq_alloc_descriptor_at , which says "I need this exact irq",
> or from irq_alloc_desc, which says "give me any irq".

That does not prevent a caller with uses irq_alloc_descs() directly
with the wrong arguments. So we want to sanity check this.
 
Thanks,

	tglx
