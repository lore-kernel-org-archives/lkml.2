Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1HKTuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:50:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16076 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1HKTuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:50:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 11 Aug 2011 12:49:54 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Aug 2011 12:49:47 -0700
Subject: RE: [PATCH] ARM: tegra: Fix <mach/gpio.h> to have necessary
 #includes
Thread-Topic: [PATCH] ARM: tegra: Fix <mach/gpio.h> to have necessary
 #includes
Thread-Index: AcxYXw7WmPKMv0K1TpqJcXhal8LApA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24CD0@HQMAIL01.nvidia.com>
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

Russell King wrote at Thursday, August 11, 2011 1:36 PM:
> On Thu, Aug 11, 2011 at 12:05:52PM -0600, Stephen Warren wrote:
> > Without this, EINVAL isn't defined, and type bool isn't declared.
> > This leads to compilation failures.
> 
> An alternative approach would be to convert tegra to be able to use
> the gpiolib __gpio_to_irq() for the on-SoC stuff, and eliminate
> irq_to_gpio().
> 
> Would it be possible to do that instead?

That should work too.

I posted a couple patches last Friday to remove irq_to_gpio:

https://lkml.org/lkml/2011/8/5/343
https://lkml.org/lkml/2011/8/5/342

Later in the thread, you said you would merge them into your branch to
avoid merge conflicts with the other GPIO work you were doing.

For gpio_to_irq, yes, I believe we get rid of it pretty easily; we'd
just need to implement gpio-tegra.c's gpio_chip.to_irq function. Should
I cook up a patch based on top of linux-next plus the two patches above
to do that instead?

Thanks.

-- 
nvpublic

