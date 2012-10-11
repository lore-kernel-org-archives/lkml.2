Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab2JKDy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:54:28 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:23640 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab2JKDyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:54:25 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 10 Oct 2012 20:21:29 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: RE: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Thread-Topic: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Thread-Index: AQHNo3hc5XW/z7cpP0CALRtkIzq7N5exEeCAgAAMXICAAmLQUw==
Date: Thu, 11 Oct 2012 03:56:22 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922C22BE7@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
 <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>,<20121009082719.GC8237@opensource.wolfsonmicro.com>
In-Reply-To: <20121009082719.GC8237@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.10.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Tue, Oct 09, 2012 at 09:43:13AM +0200, Linus Walleij wrote:
> > On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
> > > + * @cs_assert - For systems where the SPI subsystem does not control
> > > the CS/SSB + * line, or where such control is broken, you can provide a
> > > custom routine to + * handle a GPIO as CS/SSB.  This routine will be
> > > called at the beginning and + * end of each SPI transaction.  The RMI
> > > SPI implementation will wait + * pre_delay_us after this routine
> > > returns before starting the SPI transfer; + * and post_delay_us after
> > > completion of the SPI transfer(s) before calling it + * with
> > > assert==FALSE.
> > 
> > Hm hm, can you describe the case where this happens?
> > 
> > Usually we don't avoid fixes for broken drivers by duct-taping
> > solutions into other drivers, instead we fix the SPI driver.
> > 
> > I can think of systems where CS is asserted not by using
> > GPIO but by poking some special register for example, which
> > is a valid reason for including this, but working around broken
> > SPI drivers is not a valid reason to include this.
> > 
> > (Paging Mark about it.)
> 
> Yeah, this seems silly - by this logic we'd have to go round implementing
> manual /CS control in every single SPI client driver which isn't
> terribly sensible.  The driver should just assume that the SPI
> controller does what it's told.  As you say if there's an issue the
> relevant controller driver should take care of things.
> 
> We should also have generic support in the SPI framework for GPIO based
> /CS, there's enough drivers open coding this already either due to
> hardware limitations or to support extra chip selects.
> 
> The ability of SPI hardware and driver authors to get /CS right is
> pretty depressing :/

You will get no argument at all from me on that point.  I'll even add board layout engineers to the list ("it wasn't convenient to run CS, so we just used a different pin.  You can just mux it, right?").  Basically this feature exists to help get prototype systems up and running while the SPI hardware/driver/layout matures.

If this feature is a deal-breaker, we can take it out.  In the absence of a generic GPIO implementation for CS, though, I'd much rather leave it in.  Once generic GPIO CS arrives, we'll remove it pretty quickly.  

