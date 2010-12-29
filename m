Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0L2Ajq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 19:39:46 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:33440 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0L2Ajo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 19:39:44 -0500
Subject: Re: [RFC/PATCH 0/3] TWL4030 IRQ Changes
From: Felipe Balbi <me@felipebalbi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101228174138.GA3089@opensource.wolfsonmicro.com>
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
	 <1293556459-28613-1-git-send-email-balbi@ti.com>
	 <20101228173604.GH2239@legolas.emea.dhcp.ti.com>
	 <20101228174138.GA3089@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 02:39:37 +0200
Message-ID: <1293583177.1822.4.camel@eowin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2010-12-28 at 17:41 +0000, Mark Brown wrote:
> > when we finally move to struct irq_data, the below could
> > be used. BTW, Thomas do you have any plans for exposing
> > irq_data_to_desc() ?
> 
> The general idea is to move to struct irq_data sooner rather than later
> (all the existing MFD drivers have already been converted).

Great, I'll put this one together then.

> > -static void twl4030_sih_mask(unsigned irq)
> > +/* REVISIT define it here until IRQ Subsystem exports its implementation */
> > +#define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
> 
> It looks like all you're using this for is to get the chip_data?  If
> that is the case you're looking for irq_data_get_irq_chip_data() which
> will go directly from the irq_data to the chip_data.  I may have missed
> something, I only scanned the code.

you're right, just didn't know that was such a helper. BTW, quite a big
name.

-- 
balbi

