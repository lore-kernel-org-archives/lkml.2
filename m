Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0CXXIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:08:49 -0400
Received: from www.tglx.de ([62.245.132.106]:34947 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab0CXXIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:08:47 -0400
Date: Thu, 25 Mar 2010 00:08:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Thomas Gleixner wrote:

> On Wed, 24 Mar 2010, Andi Kleen wrote:
> 
> > Prevent nested interrupts when the IRQ stack is near overflowing v2
> > 
> > Interrupts can always nest when they don't run with IRQF_DISABLED.
> > 
> > When a lot of interrupts hit the same vector on the same
> > CPU nested interrupts can overflow the irq stack and cause hangs.

That's utter nonsense. An interrupt storm on the same vector does not
cause irq nesting. The irq code prevents reentering a handler and in
case of MSI-X it just disables the IRQ when it comes again while the
first irq on that vector is still in progress. So the maximum nesting
is two up to handle_edge_irq() where it disables the IRQ and returns
right away.

Thanks,

	tglx


