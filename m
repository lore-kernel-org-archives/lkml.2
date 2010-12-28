Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab0L1Rla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:41:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35383 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753844Ab0L1Rl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:41:28 -0500
Date: Tue, 28 Dec 2010 17:41:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH 0/3] TWL4030 IRQ Changes
Message-ID: <20101228174138.GA3089@opensource.wolfsonmicro.com>
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
 <1293556459-28613-1-git-send-email-balbi@ti.com>
 <20101228173604.GH2239@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228173604.GH2239@legolas.emea.dhcp.ti.com>
X-Cookie: You will have a long and boring life.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 07:36:04PM +0200, Felipe Balbi wrote:

> when we finally move to struct irq_data, the below could
> be used. BTW, Thomas do you have any plans for exposing
> irq_data_to_desc() ?

The general idea is to move to struct irq_data sooner rather than later
(all the existing MFD drivers have already been converted).

> -static void twl4030_sih_mask(unsigned irq)
> +/* REVISIT define it here until IRQ Subsystem exports its implementation */
> +#define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)

It looks like all you're using this for is to get the chip_data?  If
that is the case you're looking for irq_data_get_irq_chip_data() which
will go directly from the irq_data to the chip_data.  I may have missed
something, I only scanned the code.
