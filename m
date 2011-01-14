Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1ANWYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:24:07 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48744 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1ANWYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:24:06 -0500
Date: Fri, 14 Jan 2011 15:24:01 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: David Brownell <david-b@pacbell.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        David Woodhouse <dwmw2@infradead.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH] mtd: sst25l: fix reads with broken spi-masters
Message-ID: <20110114222401.GA10504@angua.secretlab.ca>
References: <0D753D10438DA54287A00B027084269764CDF4146A@AUSP01VMBX24.collaborationhost.net>
 <909411.87280.qm@web180312.mail.gq1.yahoo.com>
 <0D753D10438DA54287A00B027084269764CDF41635@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764CDF41635@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 04:36:50PM -0600, H Hartley Sweeten wrote:
> On Monday, January 10, 2011 3:20 PM, David Brownell wrote:
> > --- On Mon, 1/10/11, H Hartley Sweeten <hartleys@visionengravers.com> wrote:
> > NAK.  I'm surprised you even thought to submit
> > such a clearly-wrong patch.
> >
> > The bug is in the SPI master driver, and thus
> > so should the fix be.  Or make your system use
> > the GPIO based SPI master driver.
> 
> Sorry.
> 
> The bug _is_ in the spi peripheral on the ep93xx.
> 
> Unfortunately, hardware does exist that uses the SFRMOUT signal as part of
> the chip select to access the device.  The only way to get this signal to
> do anything is by using the spi peripheral.  The SFRMOUT signal cannot be
> accessed using GPIO so the GPIO based SPI master driver is not an option.

No, David is correct.  The fault is in the master driver.  It is perfectly valid (and common) for spi peripherals to required the SS line to remain asserted over the entire transfer.  Unfortunately, it is also as common for spi master devices to not support this mode in hardware.

However, the fault is with the spi master hardware, and therefore it is the responsibility of the master driver to handle the buffering and magic required so that the transfer proceeds correctly.

g.

