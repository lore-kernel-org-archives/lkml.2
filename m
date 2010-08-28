Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0H1RUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 13:20:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45760 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab0H1RUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 13:20:12 -0400
Date: Sat, 28 Aug 2010 19:20:10 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
Message-ID: <20100828172010.GJ1473@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <201008281727.10913.marek.vasut@gmail.com> <20100828161858.GI1473@pengutronix.de> <201008281830.05208.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201008281830.05208.marek.vasut@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:09:08 up 56 days,  8:19,  6 users,  load average: 1.49, 2.38,
	1.43
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 06:30:05PM +0200, Marek Vasut wrote:
> Dne So 28. srpna 2010 18:18:58 Sascha Hauer napsal(a):
> > On Sat, Aug 28, 2010 at 05:27:10PM +0200, Marek Vasut wrote:
> > > Dne So 28. srpna 2010 17:18:17 Linus Walleij napsal(a):
> > > > 2010/8/23 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > > > >> +     evt = readl(SDMA_H_EVTOVR);
> > > > >> +     mcu = readl(SDMA_H_HOSTOVR);
> > > > >> +     dsp = readl(SDMA_H_DSPOVR);
> > > > > 
> > > > > __raw_readl?
> > > > 
> > > > Sorry I never understood this __raw_[read|write][b|w|l] vs.
> > > > plain read[b|w|l] proliferation in some drivers and code.
> > > > 
> > > > What's the reason for?
> > > 
> > > Hey,
> > > 
> > > this trick is, if you create the VA<->PA mapping at the kernel start (eg.
> > > see how pxa_map_io() is replacedon some devices for instance), you then
> > > use the VA address you specified and use __raw_{read,write}[b,w,l](). So
> > > use __raw_{read,write}[b,w,l]() on drivers specific for certain device
> > > and use {read,write}[b,w,l]() on ioremap()ed memory areas, aka. in
> > > common drivers.
> > 
> > Nope, this has nothing to do with static mappings vs. ioremap. The
> > difference is that read[b,w,l] do little endian accesses suitable for
> > PCI whereas the __raw_* functions do accesses in CPU endianess.
> > Peripherals integrated into a SoC like the SDMA engine here are
> > normally accessible in native endianess and thus need the __raw_*
> > functions. An external network controller (for example a LAN9117) will
> > probably need the non raw functions. Note that 99% of the arm users use
> > little endian only and thus cpu_to_le* is a noop, so both types will work
> > for most people.
> 
> Sorry, you got me here. Why do we have io{read,write} then btw. ? That's for 
> x86's io space, right ?

Looking at the implementation in lib/iomap.c it seems that
io{read,write} can do both PIO and MMIO accesses depending on the
address given to them.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
