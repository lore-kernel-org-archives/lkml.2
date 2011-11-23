Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab1KWJ7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:59:40 -0500
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:44342 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756876Ab1KWJ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:59:36 -0500
Date: Wed, 23 Nov 2011 10:59:12 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: w.sang@pengutronix.de, broonie@opensource.wolfsonmicro.com
Cc: Wim@vger.kernel.org, wim@iguana.be, Welte@vger.kernel.org,
        Van@vger.kernel.org, Sebroeck@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com, Harald@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173227.GK6624@sirena.org.uk>
 <20111122184051.GA30941@pengutronix.de>
In-Reply-To: <20111122184051.GA30941@pengutronix.de>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14118784833490700079
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrtdegucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenuc
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <w.sang@pengutronix.de> wrote:

> On Tue, Nov 22, 2011 at 05:32:28PM +0000, Mark Brown wrote:
> > On Tue, Nov 22, 2011 at 06:05:48PM +0100, Marc Vertes wrote:
> > 
> > > +static int wdt_start(struct watchdog_device *wdev)
> > > +{
> > > +	/* Nothing to do. The watchdog can only be started by the BIOS. */
> > > +	return 0;
> > > +}
> > 
> > Shouldn't we just update the framework to cope with missing functions?
>
> For start(), I dunno. I don't have enough experience with watchdog drivers to
> judge if this is acceptable, although I'd think so. For stop(), a few drivers
> already activate a timer to keep the watchdog happy; such a mechanism should
> definately go into the core. It's in my todo-list, but I won't be angry if
> someone is faster ;)

A question regarding "nowayout", in the case of this VIA chipset where
a watchdog can not be stopped once started from BIOS. I think I should
set unconditionally WDOG_NO_WAY_OUT in status, shouldn't I ?

I also do not think it is correct to implement a timer and ping
proactively in case of magicclose because 1) it complicates a bit the
code, 2) there is no way to know the timeout value, and it set very low
in the BIOS (1 s).

Regards,
--
Marc
