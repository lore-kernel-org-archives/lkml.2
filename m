Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1HSEqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 00:46:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41738 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750859Ab1HSEqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 00:46:46 -0400
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, sdharia@codeaurora.org,
        David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201108171600.37791.arnd@arndb.de>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
	 <201108171242.24918.arnd@arndb.de>
	 <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
	 <201108171600.37791.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Fri, 19 Aug 2011 12:24:44 +0900
Message-ID: <1313724284.19990.136.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 16:00 +0200, Arnd Bergmann wrote:

> How about a mixed model then?

> I can see three relevant cases to consider:

> 1. A simple potentially hotplugged device that registers itself to the bus
>    can be automatically matched to the driver.
> 2. A device tree representation for hardwired devices that require
>    something to happen in order to register to the bus (clock, regulator,
>    ...).
> 3. A hardcoded list of devices on a slimbus host for stuff that is known
>    to be there, e.g. on a PCI card that has its own driver and that
>    also need some special setup as in case 2.

> I think in all three cases, we should identify the device by its EA and
> match that to the device driver. We create the slim_device and register
> it to the bus as soon as one of the three above is found, but in case 2
> and 3, the driver is responsible for the device to actually become active
> on the bus before it's allowed to send any commands to it.

Yes, I think that makes sense and it matches what we're doing with the
other subsystems well. We should be able to make the drivers work with
all cases. Probably the probe function should have a flag and/or query
function to let the driver know if the device has actually appeared yet.

> For the device tree binding, I would suggest defining a slimbus bus to
> have #address-cells=1, #size-cells=0 and just put the EA into the reg
> property. This is enough for the host driver to add create a
> slim_device and match a driver to it. The driver can access all the
> properties from the device_node (or platform_data in case of statically
> defined devices). When the physical device shows up on the bus, it is
> automatically associated with the existing slim_device.

Sounds reasonable I'd need to actually look at the specs again for the
details.

