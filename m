Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1LVRpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:45:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44997 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1LVRps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:45:48 -0500
Date: Thu, 22 Dec 2011 09:45:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: serio: ams-delta: toggle keyboard power over GPIO
Message-ID: <20111222174537.GB21103@core.coreip.homeip.net>
References: <378bcda9c6cb6a1ddeeb54817078bc7ec68c5987.1324331816.git.jkrzyszt@tis.icnet.pl>
 <1324419034-31024-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <20111221190945.GD24444@atomide.com>
 <201112212055.10343.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112212055.10343.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 08:55:09PM +0100, Janusz Krzysztofik wrote:
> On Wednesday 21 of December 2011 at 20:09:45, Tony Lindgren wrote:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111220 13:39]:
> > > Don't use Amstrad Delta custom I/O functions once GPIO interface is
> > > available for the underlying hardware.
> > > 
> > > While requesting and initializing GPIO pins used, also take care of one
> > > extra pin KEYBRD_DATAOUT which, even if not used by the driver, belongs
> > > to the device and affects its functioning.
> > > 
> > > Once done, move the driver initialization back to the device_initcall
> > > level, reverting the temporary chane introduced with patch 1/7 "ARM:
> > > OMAP1: ams-delta: register latch dependent devices later".  That change
> > > is no longer required once the driver takes care of registering used
> > > GPIO pins, and it's better to initialize the device before others using
> > > the latch2 based GPIO pins, otherwise a garbage is reported on boot,
> > > perhaps due to random data already captured by the FIQ handler while the
> > > keyboard related latch bits are written with random values during
> > > initialization of those other latch2 dependent devices.
> > > 
> > > Depends on patch 2/7 "ARM: OMAP1: ams-delta: convert latches to
> > > basic_mmio_gpio"
> > > 
> > > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > 
> > I'm assuming Dmitry's ack for an earlier version of this patch also
> > covers this one when applying.
> 
> Hi Dmitry,
> Can we assume your ack still valid for this version?
> 

Yes, please merge with your other changes.

BTW, if you could rename :static struct gpio _gpios" to "ams_delta_gpios"
that would be even better.

Thanks!

-- 
Dmitry
