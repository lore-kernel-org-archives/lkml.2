Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887Ab2LFHpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:45:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6080 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831Ab2LFHpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:45:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 05 Dec 2012 23:44:53 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC] gpiolib: introduce descriptor-based GPIO interface
Date: Thu, 6 Dec 2012 16:45:17 +0900
Message-ID: <1354779918-4028-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.0.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a RFC to check if the direction seems good before going onward with more
serious work. This patch introduces a set of gpiod_* functions that work like
their gpio_* counterparts, but use opaque descriptors instead of integers.

The current integer-based GPIO namespace is bad because it allows GPIOs to be
used without being properly allocated, and poses portability concerns with the
maximum number of GPIOs of the system being a compile-time constant. Some
implementation details could also be improved by an opaque handler, e.g. the
GPIO descriptors could be moved from the current static array to a more flexible
list of GPIO chips containing their own descriptors.

With this patch GPIO handles can only be obtained by calling gpio_to_desc(),
which converts a valid GPIO number to its descriptor - proper lookup functions
that totally get rid of GPIO numbers are the next step if this first patch is
received positively.

This is only a first step towards a bigger gpiolib rework. Getting rid of the
integer handles for GPIOs will allow us to continue on with the following:
* Proper GPIO lookup functions a la regulator, pwm, etc.
* Getting rid of ARCH_NR_GPIO,
* Tearing out asm-generic/gpio.h into consumer/driver include files,
* ...

This API is only available if gpiolib is compiled in. One could however easily
implement a set of gpiod_* functions that would wrap around the old interface if
that was deemed necessary.

Comments and thoughts on potential issues are welcome, at this stage it is very
possible that I missed a few issues that will arise in later stages of this
project.

Alexandre Courbot (1):
  gpiolib: introduce descriptor-based GPIO interface

 drivers/gpio/gpiolib.c        | 302 ++++++++++++++++++++++--------------------
 include/asm-generic/gpio.h    |  74 ++++++++---
 include/linux/gpio/consumer.h |  45 +++++++
 3 files changed, 261 insertions(+), 160 deletions(-)
 create mode 100644 include/linux/gpio/consumer.h

-- 
1.8.0.1

