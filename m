Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1FBNhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:37:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36956 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1FBNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:37:49 -0400
Date: Thu, 2 Jun 2011 14:37:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd wm8350: allocate irq descs dynamically
Message-ID: <20110602133743.GA4253@sirena.org.uk>
References: <20110602114502.GO23771@pengutronix.de> <20110602115349.GF3085@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602115349.GF3085@opensource.wolfsonmicro.com>
X-Cookie: Wanna buy a duck?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 12:53:49PM +0100, Mark Brown wrote:
> On Thu, Jun 02, 2011 at 01:45:02PM +0200, Sascha Hauer wrote:
> > 
> > This allows boards to leave the irq_base field unitialized and
> > prevents them having to reserve irqs in the platform.
> > pdata can be optional for irq support now. Without pdata the
> > driver allocates some free irq range. With pdata and irq_base > 0
> > the driver allocates exactly the specified irq.
> > Without pdata the irq defaults to IRQF_TRIGGER_LOW.

> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Actually I take that back, it looks like the wm831x equivalent patch is
causing some sort of semi-intermittent issue with the IRQ infrastructure
on non-sparse systems so I suspect this patch is also problematic.  The
major symptom is lockups in softirq handling.
