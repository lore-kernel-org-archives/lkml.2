Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2JDJMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:12:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50580 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2JDJMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:12:02 -0400
Date: Thu, 4 Oct 2012 11:11:45 +0200
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
Message-ID: <20121004091145.GA3317@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349276133-26408-1-git-send-email-mporter@ti.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:43:06 up  1:11,  8 users,  load average: 0.04, 0.05, 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 10/3/12, Matt Porter <mporter@ti.com> wrote:
> This series enables uio_pruss on DA850 and removes use of the
> private SRAM API by the driver. The driver previously was not
> enabled by any platform and the private SRAM API was accessing
> an invalid SRAM bank.

have you seen my SRAM patch series at https://lkml.org/lkml/2012/9/7/281
"Add device tree support for on-chip SRAM" ?

I think the generic SRAM/genalloc driver (https://lkml.org/lkml/2012/9/7/282)
could be useful to map the L3RAM on Davinci.
With the gen_pool lookup patch (https://lkml.org/lkml/2012/9/7/284) the
uio_pruss driver could then use the gen_pool_find_by_phys() (or
of_get_named_gen_pool() for initialization from device tree) to
retrieve the struct gen_pool*.

This way you could avoid handing it over via platform data and you could
get rid of arch/arm/mach-davinci/{sram.c,include/mach/sram.h} completely.

regards
Philipp

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
