Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0L1PqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 10:46:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45139 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0L1PqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 10:46:22 -0500
Date: Tue, 28 Dec 2010 15:46:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH 1/2] mfd: twl6030-irq: move to threaded_irq
Message-ID: <20101228154617.GC14860@sirena.org.uk>
References: <1293544790-793-1-git-send-email-balbi@ti.com> <1293544790-793-2-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293544790-793-2-git-send-email-balbi@ti.com>
X-Cookie: George Orwell was an optimist.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 03:59:49PM +0200, Felipe Balbi wrote:

> +	disable_irq_nosync(irq);

You shouldn't need this any more; the driver used to be faffing around
with this because it wasn't using genirq for this in the past.

> +	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++) {
> +		local_irq_disable();

Simiarly here as far as I know; the original code predates genirq
support for this so is doing some hairy stuff that is no longer
required and may actually be harmful.

What I'd expect to see from a conversion like this would be that most of
the locking/IRQ management stuff would be dropped and the bus_lock() and
bus_sync_unlock() operations would be implemented.
