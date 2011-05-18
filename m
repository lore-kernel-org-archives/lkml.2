Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732Ab1ERTXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:23:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933632Ab1ERTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:23:51 -0400
Date: Wed, 18 May 2011 12:23:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv2 -next] LEDS: LED module of DA9052 PMIC driver
Message-Id: <20110518122332.94d4fdb9.akpm@linux-foundation.org>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC621FA@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC621FA@KCINPUNHJCMS01.kpit.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 17:22:28 +0530
Ashish Jangam <Ashish.Jangam@kpitcummins.com> wrote:

> LED Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . added patches as a merger plan for LED

 drivers/input/misc/Kconfig          |    7 
 drivers/input/misc/Makefile         |    1 
 drivers/input/misc/da9052_onkey.c   |  166 +++++++
 drivers/leds/Kconfig                |    8 
 drivers/leds/Makefile               |    1 
 drivers/leds/leds-da9052.c          |  216 +++++++++
 drivers/mfd/Kconfig                 |   25 +
 drivers/mfd/Makefile                |    7 
 drivers/mfd/da9052-core.c           |  487 +++++++++++++++++++++
 drivers/mfd/da9052-i2c.c            |  170 +++++++
 drivers/mfd/da9052-irq.c            |  313 +++++++++++++
 drivers/mfd/da9052-spi.c            |  183 ++++++++
 drivers/video/backlight/Kconfig     |    6 
 drivers/video/backlight/Makefile    |    1 
 drivers/video/backlight/da9052_bl.c |  216 +++++++++
 drivers/watchdog/Kconfig            |    6 
 drivers/watchdog/Makefile           |    1 
 drivers/watchdog/da9052_wdt.c       |  464 ++++++++++++++++++++
 include/linux/mfd/da9052/da9052.h   |   89 +++
 include/linux/mfd/da9052/irq.h      |   86 +++
 include/linux/mfd/da9052/pdata.h    |   46 ++
 include/linux/mfd/da9052/reg.h      |  822 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9052/wdt.h      |   67 ++
 23 files changed, 3388 insertions(+)

This is a huge patch which affects multiple separately-maintained
subsystems.  I can't take it as-is and it's not compileable in a tree
which doesn't define CONFIG_PMIC_DA9052.


A way to proceed with this patchset is to get the core PMIC_DA9052
support patch merged and to then send the various dependent patches to
the relevant maintainers.

What _is_ the core patch, btw?  Seems that it's "MFD: MFD module of
DA9052 PMIC driver".

An alternative way of getting it all merged up is for us to ask Samuel
to merge _all_ the patches, after receiving suitable acks and reviews
from suitable people.  Or I can do that.

I think the second way is better.  Sam?

