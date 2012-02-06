Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2BFF4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 00:56:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35538 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2BFF4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 00:56:14 -0500
Date: Sun, 5 Feb 2012 22:56:09 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
Message-ID: <20120206055609.GA21449@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <20120204221748.GN14129@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120204221748.GN14129@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 10:17:48PM +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 27, 2012 at 02:35:54PM -0700, Grant Likely wrote:
> > Hey everyone,
> > 
> > This patch series is ready for much wider consumption now.  I'd like
> > to get it into linux-next ASAP because there will be ARM board support
> > depending on it.  I'll wait a few days before I ask Stephen to pull
> > this in.
> 
> Grant,
> 
> Can you answer me this: does this irqdomain support require DT?

No, it should not.  Any situation where it does is a bug.

> Now, here's the thing: I believe that IRQ domains - at least as far as
> the hwirq stuff - should be available irrespective of whether we have
> the rest of the IRQ domain support code in place, so that IRQ support
> code doesn't have to keep playing games to decode from the global
> space to the per-controller number space.

Correct.  That's the intent.  My new series flushes out irq_domain quite a
bit better and gets all architectures doing the same thing if they use
irq_domains.  I've done some testing on both CONFIG_OF and !CONFIG_OF builds,
but I'm going to do some more to make sure I've not missed anything.

> I believe that would certainly help the current OMAP problems, where
> the current lack of CONFIG_IRQ_DOMAIN basically makes the kernel oops
> on boot.
> 
> How we fix this regression for 3.4 I've no idea at present, I'm trying
> to work out what the real dependencies are for OMAP on this stuff.
> 
> Finally, do we need asm/irq.h in our asm/prom.h ?  That's causing
> fragility between DT and non-DT builds, because people are finding
> that their DT builds work without their mach/irqs.h includes but
> fail when built with non-DT.  The only thing which DT might need -
> at the most - is NR_IRQS, but I'd hope with things like irq domains
> it doesn't actually require it.

I don't think so.  There may be a file or two that break because they're
not including everything they need, but I don't think anything in the
header requires it.

The irq_domain code is well isolated.  The header file doesn't need to
be including it.

g.
