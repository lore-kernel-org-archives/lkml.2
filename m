Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1AJWg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:36:56 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:19025 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1AJWgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:36:54 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1294698901!6406458!80
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: David Brownell <david-b@pacbell.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
CC: David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>
Date: Mon, 10 Jan 2011 16:36:50 -0600
Subject: RE: [PATCH] mtd: sst25l: fix reads with broken spi-masters
Thread-Topic: [PATCH] mtd: sst25l: fix reads with broken spi-masters
Thread-Index: AcuxFJOmPRs+O0kiRYKLTm450+HdsQAABjJg
Message-ID: <0D753D10438DA54287A00B027084269764CDF41635@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B027084269764CDF4146A@AUSP01VMBX24.collaborationhost.net>
 <909411.87280.qm@web180312.mail.gq1.yahoo.com>
In-Reply-To: <909411.87280.qm@web180312.mail.gq1.yahoo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 10, 2011 3:20 PM, David Brownell wrote:
> --- On Mon, 1/10/11, H Hartley Sweeten <hartleys@visionengravers.com> wrote:
> NAK.  I'm surprised you even thought to submit
> such a clearly-wrong patch.
>
> The bug is in the SPI master driver, and thus
> so should the fix be.  Or make your system use
> the GPIO based SPI master driver.

Sorry.

The bug _is_ in the spi peripheral on the ep93xx.

Unfortunately, hardware does exist that uses the SFRMOUT signal as part of
the chip select to access the device.  The only way to get this signal to
do anything is by using the spi peripheral.  The SFRMOUT signal cannot be
accessed using GPIO so the GPIO based SPI master driver is not an option.

If the SFRMOUT signal is _not_ used in the chip select logic then everything
works fine.

But... If it's a NAK.. It's a NAK...  I'll try to figure out a way to handle
this in the SPI master driver.

Regards,
Hartley



