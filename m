Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab2DBUwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:52:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:51473 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2DBUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:52:40 -0400
Date: Mon, 2 Apr 2012 22:52:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Schwab <schwab@linux-m68k.org>
cc: Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
In-Reply-To: <m2hax2qeqs.fsf@igel.home>
Message-ID: <alpine.LFD.2.02.1204022251420.2542@ionos>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca> <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2012, Andreas Schwab wrote:

> Andreas Schwab <schwab@linux-m68k.org> writes:
> 
> > Grant Likely <grant.likely@secretlab.ca> writes:
> >
> >> This patch drops the powerpc-specific irq_map table and replaces it with
> >> directly using the irq_alloc_desc()/irq_free_desc() interfaces for allocating
> >> and freeing irq_desc structures.
> >
> > This breaks irqs on PowerMac G5.  I see lost irq errors from the sata
> > driver.
> 
> When I revert a09b659cd68c10ec6a30cb91ebd2c327fcd5bfe5 ("genirq: Fix
> long-term regression in genirq irq_set_irq_type() handling") on top of
> 3.4-rc1 the sata irq errors disappear, but I see a lot of spurious

Hmm. Which irq chip is handling the interrupt for that sata irq ?

Thanks,

	tglx
