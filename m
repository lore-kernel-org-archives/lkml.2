Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2DBVUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:20:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:40700 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2DBVUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:20:39 -0400
Message-ID: <1333401600.30734.56.camel@pasglop>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Tue, 03 Apr 2012 07:20:00 +1000
In-Reply-To: <alpine.LFD.2.02.1204022251420.2542@ionos>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	 <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	 <alpine.LFD.2.02.1204022251420.2542@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 22:52 +0200, Thomas Gleixner wrote:
> > When I revert a09b659cd68c10ec6a30cb91ebd2c327fcd5bfe5 ("genirq: Fix
> > long-term regression in genirq irq_set_irq_type() handling") on top
> of
> > 3.4-rc1 the sata irq errors disappear, but I see a lot of spurious
> 
> Hmm. Which irq chip is handling the interrupt for that sata irq ?

MPIC. The irq is a PCI IRQ, and so should be level-low, it should have
been mapped by the PCI code using the of_* calls.

Cheers,
Ben.


