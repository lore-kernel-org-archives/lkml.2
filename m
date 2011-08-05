Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1HEPaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:30:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19152 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1HEP37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:29:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 05 Aug 2011 08:29:39 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>, "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 5 Aug 2011 08:29:38 -0700
Subject: RE: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Thread-Topic: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Thread-Index: AcxTMXR1XXCeYTGoT52Q1ob/Xae7iwAUpNbw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049F171EF4@HQMAIL01.nvidia.com>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com>
 <1312498820-2275-2-git-send-email-swarren@nvidia.com>
 <20110805000148.GB13321@opensource.wolfsonmicro.com>
 <74CDBE0F657A3D45AFBB94109FB122FF049F171EC1@HQMAIL01.nvidia.com>
 <20110805053510.GA16956@opensource.wolfsonmicro.com>
In-Reply-To: <20110805053510.GA16956@opensource.wolfsonmicro.com>
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

Mark Brown wrote at Thursday, August 04, 2011 11:35 PM:
> On Thu, Aug 04, 2011 at 08:53:34PM -0700, Stephen Warren wrote:
> 
> > Well, things break. This is essentially the problem I was describing in
> > the PATCH 0 email, just with a slightly different motivation.
> 
> There's a bunch of existing code using that idiom.

Certainly.

> > I suppose that an alternative here would be to simply ignore any errors
> > from gpio_request. This might have the benefit of removing the need for
> > the other two patches I posted in the series. However, it seems a little
> > dirty; one benefit of the IRQ code calling gpio_request and honoring
> > errors would be to detect when some completely unrelated code had a bug
> > and had called gpio_request on the GPIO before. Such detection would be
> > non-existent if we don't error out on gpio_request. Perhaps some mechanism
> > is needed to indicate that the driver has explicitly already called
> > gpio_request for a legitimate shared purpose, and only then ignore
> > errors?
> 
> But it's not a bug to use a GPIO as an IRQ source, otherwise we wouldn't
> have gpio_to_irq() in the first place.

True, but I think there are two cases:

1) Some code legitimately uses a pin as both a GPIO and IRQ, and is fully
cognizant of the fact, just like in your example -> no bug.

2) Two pieces of unrelated code somehow accidentally get a GPIO and IRQ
number that map to the same resource, e.g. due to incorrect board files or
Device Tree content. This is probably a bug, but ends up looking exactly
the same as far as the IRQ code's gpio_request call failing in the patch I
posted.

> Feels like we need a backchannel
> between gpiolib and the IRQ code to do this.  Or perhaps the drivers
> that implement this should be taking care of setting up the GPIO mode?

-- 
nvpublic

