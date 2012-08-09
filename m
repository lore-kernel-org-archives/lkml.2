Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2HIMFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:05:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54993 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2HIMFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:05:44 -0400
Date: Thu, 9 Aug 2012 13:05:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Wei Ni <wni@nvidia.com>,
        linux-wireless@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        brcm80211-dev-list@broadcom.com, linux-kernel@vger.kernel.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        frankyl@broadcom.com, linux-tegra@vger.kernel.org
Subject: Re: How to get the irq flags from the dts file
Message-ID: <20120809120530.GC8474@sirena.org.uk>
References: <1344509006.2295.148.camel@tegra-chromium-2>
 <201208091148.42748.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208091148.42748.arnd@arndb.de>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 11:48:42AM +0000, Arnd Bergmann wrote:
> On Thursday 09 August 2012, Wei Ni wrote:

> > The wlan driver wish this flags include the IRQF_TRGGER_* information,
> > and it will use this flags to configure other hw settings. If it is
> > wrong, the wlan can't work.

You can read the configuration with irqd_get_trigger_type() - see the OF
code in sound/soc/codecs/wm8903.c for an example.

> The driver should not need to know about thie flag. It gets read
> by irq_create_of_mapping when calling teh xlate function and
> gets set using irq_set_irq_type from there too.

That only helps the interrupt controller, it doesn't help the interrupt
source.  A good proportion of embedded devices have a great deal of
flexibility in how they signal interrupts so they need to know what mode
to pick.
