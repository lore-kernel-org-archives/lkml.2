Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2DBWcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:32:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:50576 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab2DBWcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:32:52 -0400
Message-ID: <1333405938.30734.60.camel@pasglop>
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
Date: Tue, 03 Apr 2012 08:32:18 +1000
In-Reply-To: <alpine.LFD.2.02.1204022324140.2542@ionos>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	 <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	 <alpine.LFD.2.02.1204022251420.2542@ionos>
	 <1333401600.30734.56.camel@pasglop>
	 <alpine.LFD.2.02.1204022324140.2542@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 23:27 +0200, Thomas Gleixner wrote:
> So it's covered by this section:
> 
> mpic_set_irq_type()
> 
>         if (flow_type == IRQ_TYPE_NONE)
>                 if (mpic->senses && src < mpic->senses_count)
>                         flow_type = mpic->senses[src];
>         if (flow_type == IRQ_TYPE_NONE)
>                 flow_type = IRQ_TYPE_LEVEL_LOW;
> 
> And with IRQ_TYPE_NONE this is always going to end up with
> IRQ_TYPE_LEVEL_LOW simply because the only function which might set
> mpic->senses is mpic_set_default_senses(). And this function does not
> have a single caller .....
> 
> /me scratches head 

Something must have broken ... when converting from the device-tree we
should be calling xlate which should extract the polarity/sense from the
device-tree.

Now, afaik, IRQ_LEVEL_LOW is correct for PCI unless the interrupt is
inverted inside Apple ASIC which is possible... (it's not an external
PCI, it's a cell inside K2).

Cheers,
Ben.


