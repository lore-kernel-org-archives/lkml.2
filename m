Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab2JDNgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:36:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57238 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab2JDNgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:36:05 -0400
Date: Thu, 4 Oct 2012 15:35:53 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Matt Porter <mporter@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/6] uio_pruss cleanup and platform support
Message-ID: <20121004133553.GA5151@pengutronix.de>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
 <20121004091145.GA3317@pengutronix.de>
 <20121004124253.GC11149@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004124253.GC11149@beef>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:52:23 up  5:21, 12 users,  load average: 0.00, 0.01, 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 08:42:53AM -0400, Matt Porter wrote:
> > I think the generic SRAM/genalloc driver (https://lkml.org/lkml/2012/9/7/282)
> > could be useful to map the L3RAM on Davinci.
> > With the gen_pool lookup patch (https://lkml.org/lkml/2012/9/7/284) the
> > uio_pruss driver could then use the gen_pool_find_by_phys() (or
> > of_get_named_gen_pool() for initialization from device tree) to
> > retrieve the struct gen_pool*.
> > 
> > This way you could avoid handing it over via platform data and you could
> > get rid of arch/arm/mach-davinci/{sram.c,include/mach/sram.h} completely.
> 
> I did miss the gen_pool_find_by_phys() call in that series. That does
> look useful. I actually mentioned your series in an earlier posting
> since I like it,

That I did miss.

> but since the initialization of the driver was inherently
> tied to DT it's not usable for DaVinci that's just starting to convert
> to DT and needs !DT support as well.

There should be no dependency on DT in the sram driver. It just requests
and remaps the first given iomem resource and creates a gen_pool from that.
This should work just as well for the !DT case.
Maybe it's just my choice of patch series subject gave you that
impression? If there's a real issue for !DT, I should fix it.

> I do see it moving to your driver exclusively, but I wanted to make this
> series focused on only getting rid of the private SRAM API using the
> existing pdata framework that's already there. I think once
> gen_pool_find_by_phys() goes upstream we can switch to that and get the
> address from a resource in the !DT case. I guess we should see if Sekhar
> would like to see this happen in two steps or just have us depend on
> the gen_pool_find_by_phys() patch now.

Thanks, I'm glad you are aware of the sram driver and consider it useful.

> BTW, I was going to post a patch for your driver to allow
> configurability of the allocation order, but have been busy with other
> things.  We'll eventually need that when switching to it as the
> hardcoded page size order isn't going to work for all cases.

Good point.

regards
Philipp

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
