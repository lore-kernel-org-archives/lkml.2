Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab1E0DiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:38:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40970 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1E0DiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:38:17 -0400
Date: Thu, 26 May 2011 21:38:15 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Milton Miller <miltonm@bga.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] irq: allow a per-allocation upper limit when
 allocating irqs
Message-ID: <20110527033815.GN5032@ponder.secretlab.ca>
References: <generic-irq-changes@mdm.bga.com>
 <alloc-irq-range-v2@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alloc-irq-range-v2@mdm.bga.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 01:34:18AM -0500, Milton Miller wrote:
> Allow the option to specify an upper limit to the irq numbers for
> each allocation.  The limit is non-inclusive, and 0 means no limit
> needed by caller.
> 
> Some irq chips can support a relative large and arbitrary range,
> but not infinite.  For example, they may use the linux irq number
> as the msi desciptor data, which for msi is 16 bits.
> 
> Since e7bcecb7b1 (genirq: Make nr_irqs runtime expandable), checking
> NR_IRQS or even nr_irqs is not sufficient to enforce such requirements
> when sparse irqs are configured.
> 
> Based on an irc discussion, make the limit per call instead of an
> arch callback or global setting.
> 
> If the requested count is above the limit, return -ENOMEM as if
> nr_irqs could not be expanded, assuming the limit was specified at
> a different layer than the count.
> 
> This code does not try to keep the prior semantics of irq_alloc_descs
> when irq was non-negative but not equal to from.  I believe it was an
> implementation artifact instead of a designed feature that one could
> specify search starting from 4 and fail if the allocated irq was not
> exactly 6, confirming that the intervening irqs were reserved.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Milton Miller <miltonm@bga.com>

Looks good to me/

g.

