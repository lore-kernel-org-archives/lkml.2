Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0CYAg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:36:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58357 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab0CYAg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:36:56 -0400
Date: Thu, 25 Mar 2010 01:36:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325003652.GG20695@one.firstfloor.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 12:08:23AM +0100, Thomas Gleixner wrote:
> On Wed, 24 Mar 2010, Thomas Gleixner wrote:
> 
> > On Wed, 24 Mar 2010, Andi Kleen wrote:
> > 
> > > Prevent nested interrupts when the IRQ stack is near overflowing v2
> > > 
> > > Interrupts can always nest when they don't run with IRQF_DISABLED.
> > > 
> > > When a lot of interrupts hit the same vector on the same
> > > CPU nested interrupts can overflow the irq stack and cause hangs.
> That's utter nonsense. An interrupt storm on the same vector does not
> cause irq nesting. The irq code prevents reentering a handler and in

Sorry it's the same CPU, not the same vector.  Yes the reference
to same vector was misleading.

"
Multiple vectors on a multi port NIC pointing to the same CPU, 
all hitting the irq stack until it overflows.
"

> case of MSI-X it just disables the IRQ when it comes again while the
> first irq on that vector is still in progress. So the maximum nesting
> is two up to handle_edge_irq() where it disables the IRQ and returns
> right away.

Real maximum nesting is all IRQs running with interrupts on pointing
to the same CPU. Enough from multiple busy IRQ sources and you go boom.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
