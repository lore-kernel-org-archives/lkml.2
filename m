Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1AKNwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:52:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60416 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab1AKNw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:52:28 -0500
Date: Tue, 11 Jan 2011 14:52:14 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110111135214.GR24920@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com>
 <201101111744.59712.jeremy.kerr@canonical.com>
 <20110111101314.GA774@linux-sh.org>
 <201101111830.18597.jeremy.kerr@canonical.com>
 <20110111121816.GB774@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110111121816.GB774@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 09:18:16PM +0900, Paul Mundt wrote:
> On Tue, Jan 11, 2011 at 06:30:18PM +0800, Jeremy Kerr wrote:
> > Hi Paul,
> > 
> > > No, the sleeping clock case is and always will be a corner case, and I
> > > have no interest in pretending otherwise. On SH we have hundreds of
> > > clocks that are all usable in the atomic context and perhaps less than a
> > > dozen that aren't (and even in those cases much of the PLL negotiation is
> > > handled in hardware so there's never any visibility for the lock-down
> > > from the software side, other architectures also have similar behaviour).
> > 
> > I'm not too worried about the corner-cases on the *implementation* side, more 
> > the corner-cases on the API side: are we seeing more users of the API that 
> > require an atomic clock, or more that don't care?
> > 
> Again, you are approaching it from the angle that an atomic clock is a
> special requirement rather than the default behaviour. Sleeping for
particularly if atomic behaviour is the common behaviour it's important
to get it right, because the less common sleeping clocks don't get much
test covering.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
