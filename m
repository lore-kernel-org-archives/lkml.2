Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1HLQqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:46:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34958 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1HLQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:46:35 -0400
Date: Fri, 12 Aug 2011 17:46:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110812164608.GC28150@sirena.org.uk>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <201108111455.56319.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108111455.56319.arnd@arndb.de>
X-Cookie: You have a message from the operator.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:55:55PM +0200, Arnd Bergmann wrote:
> On Thursday 11 August 2011, Kenneth Heitke wrote:

> > +EXPORT_SYMBOL_GPL(slim_add_device);

> I don't think this should be exported: AFAICT, the set of slim_devices
> is a property of the platform, so I don't see how any other device driver
> would add another device.

The platform may be comprised of multiple hardwaare modules with
functionality on daughtercards which can be probed at runtime.  You may
also find someone constructing a PCI card or something with a slimbus
controller on it at some point.

> > +EXPORT_SYMBOL_GPL(slim_register_board_info);

> We are trying to gradually convert platforms that have hardcoded device
> lists and cannot probe devices by looking at the hardware over to using
> device tree files that list all the devices.

> I think that this would work well for slimbus and should be done
> right from the start. This means however that you should not
> register a "board_info" but instead change the slim_register_controller
> function so that it adds all devices listed as children of the
> controller in the device tree.

It seems a bit extreme to prevent anyone implementing a subsystem for
their platform until they've converted it into device tree.  Though with
slimbus it should be at least somewhat probeable IIRC?
