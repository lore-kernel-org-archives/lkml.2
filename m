Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1AKK4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:56:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46034 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab1AKK4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:56:16 -0500
Date: Tue, 11 Jan 2011 11:56:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: Locking in the clk API
Message-ID: <20110111105609.GO24920@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com>
 <20110111091607.GI12552@n2100.arm.linux.org.uk>
 <201101111744.59712.jeremy.kerr@canonical.com>
 <20110111103929.GN24920@pengutronix.de>
 <20110111104709.GB11039@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110111104709.GB11039@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Tue, Jan 11, 2011 at 10:47:09AM +0000, Russell King - ARM Linux wrote:
> On Tue, Jan 11, 2011 at 11:39:29AM +0100, Uwe Kleine-König wrote:
> > A quick look into Digi's BSP (digiEL-5.0) shows they implemented
> > something I suggested earlier here:
> >
> > [...]
> > 
> > 
> > I think the idea is nice.  At least it allows with a single lock to
> > implement both, sleeping and atomic clks without the need to mark the
> > atomicity in a global flag.
> 
> It doesn't.  clk_enable() here can still end up trying to sleep when
> it's called from IRQ context - the code doesn't solve that.  All it
> means is that the intermediate code doesn't care whether clk->endisable
> ends up sleeping or not.
Obviousley you're right and your last sentence is all I intended to
claim.

> What it does do is return -EBUSY if there are two concurrent attempts
> to enable the same clock.  How many drivers today deal sanely with
> such an error from clk_enable(), and how many would just fail their
> probe() call on such an occurance?
Yes, that's the ugly part.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
