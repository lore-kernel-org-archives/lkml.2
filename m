Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0FPVPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:15:17 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:26661 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307Ab0FPVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:15:15 -0400
Date: Wed, 16 Jun 2010 22:14:58 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: Lothar Wa?mann <LW@KARO-electronics.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100616211458.GB30005@fluff.org.uk>
References: <19473.61547.684572.647641@ipc1.ka-ro>
 <201006111718.47426.jeremy.kerr@canonical.com>
 <19474.172.742782.972629@ipc1.ka-ro>
 <20100611095839.GC10894@pengutronix.de>
 <19474.2817.333749.485028@ipc1.ka-ro>
 <1276319643.1962.181.camel@pasglop>
 <19477.52889.982995.407051@ipc1.ka-ro>
 <20100614064028.GA12159@pengutronix.de>
 <19477.53673.644128.558827@ipc1.ka-ro>
 <20100614093459.GD12159@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614093459.GD12159@pengutronix.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:34:59AM +0200, Uwe Kleine-K?nig wrote:
> Hello,
> 
> > And arch/arm/plat-s3c/clock.c has the following comment:
> > |/* We originally used an mutex here, but some contexts (see resume)
> > | * are calling functions such as clk_set_parent() with IRQs disabled
> > | * causing an BUG to be triggered.
> > | */
> > |DEFINE_SPINLOCK(clocks_lock);
> I wonder why it's needed to reparent clocks during resume.  And where
> exactly IRQs are disabled.  Hmm, this comment was initially introduced
> by v2.6.28-rc7-180-gc3391e3, its commit log talks about cpufreq, not
> resume.
> 
> Ben (Dooks): Is this still relevant?

Yes, unfortunately the system may not resume with the clock registers
in the same state as they where before, and there are things that may
need to set the parents before the resume can continue.

We may have ended up saving quite a bit of the clock state by force,
but it isn't the nicest way, and there's still issues with any clocks
that require pll stabilisation.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
