Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2DBXjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:39:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:46571 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab2DBXjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:39:32 -0400
Message-ID: <1333409927.30734.62.camel@pasglop>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andreas Schwab <schwab@linux-m68k.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 03 Apr 2012 09:38:47 +1000
In-Reply-To: <20120402225223.GN24211@n2100.arm.linux.org.uk>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	 <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	 <20120402202848.1EB833E02A7@localhost>
	 <20120402215524.GM24211@n2100.arm.linux.org.uk>
	 <1333406005.30734.61.camel@pasglop>
	 <20120402225223.GN24211@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 23:52 +0100, Russell King - ARM Linux wrote:
> If we want to fix it a better way, then sure, that'll be good.  But
> what
> we shouldn't do is re-introduce one regression to fix a different
> regression.
> 
> So, Thomas, what do you think about providing a way that a disabled
> interrupt could have its pending status cleared such that when it's
> enabled, any queued events are ignored?  Maybe an
> enable_and_clear_irq() ? 

Ok. Doesn't matter anyway, this shouldn't be the problem in this
specific case. IE. we shouldn't be setting that interrupt to NONE.

We should have parsed the device-tree and set the trigger appropriately.

Cheers,
Ben.


