Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1LMSYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:24:25 -0500
Received: from border.exmeritus.com ([70.167.241.26]:57142 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab1LMSYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:24:23 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off platform devices with GPIOs
Date: Tue, 13 Dec 2011 13:23:31 -0500
Message-Id: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

I posted this patch series a few weeks ago and saw no responses, so I
tweaked the CC list and am reposting it again for review.

I'm working on support for some custom hardware of ours, and part of
the support code is the ability for the software to shutdown the power
supply using GPIOs (via an I2C GPIO controller).

I previously had this in my platform code, but it seemed generically
useful, so I split it out into a separate module for others to use.

The first two patches are generic of_gpio enhancements, providing some
new library functions for requesting lots of GPIOs at once.

The third patch is the actual driver itself.  The driver can be used to
instantiate a platform device as a whole-machine-poweroff device as we
use it on our hardware.  Alternatively it can instantiate multiple
platform devs at specific locations on the device tree which trigger
from the platform_driver->shutdown() callback.

For architectures which are still stuck in the dark ages, this driver
also supports being instantiated via legacy platform_data.

The OpenFirmware binding documentation is added in the third patch.
Since this is my first cut, it's a little rough, so please be gentle.

I'm interested to know what you all think.

Cheers,
Kyle Moffett

--
Interested in my work on the Debian "powerpcspe" port?
I'm keeping a blog here: http://pureperl.blogspot.com/

