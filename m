Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1J2FFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 01:05:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39440 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1J2FFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 01:05:54 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 29 Oct 2011 07:05:32 +0200
X-Google-Sender-Auth: FdASWru4Ta54UhDCsq4qPyc0dgE
Message-ID: <CACxGe6tUNqg412J7=pEqpwpZtn+fn3YNNTiUScDwUMUhERjZZQ@mail.gmail.com>
Subject: [git pull] GPIO changes for 3.2
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rabin Vincent (commit_signer:2/17=12%)" 
	<rabin.vincent@stericsson.com>,
        Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Hamo <hamo.by@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the gpio changes for 3.2.  The majority of gpio changes this
cycle are actually going through rmk's tree since they are arch/arm
cleanups.  Nothing terribly exciting here except for one patch that
touches kernel/irq to export a handful of symbols which tglx acked.
That's here since an earlier commit in this tree caused a failure when
building modules.

g.

The following changes since commit ec7ae517537ae5c7b0b2cd7f562dfa3e7a05b954:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
(2011-10-28 16:44:18 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 gpio/next

Adrian Hunter (1):
      gpio: langwell: ensure alternate function is cleared

Hamo (1):
      gpio: fix build error in include/asm-generic/gpio.h

Linus Walleij (1):
      gpio/nomadik: use genirq core to track enablement

Mark Brown (2):
      gpiolib: Ensure struct gpio is always defined
      h8300: Move gpio.h to gpio-internal.h

Nobuhiro Iwamatsu (1):
      irq: Add EXPORT_SYMBOL_GPL to function of irq generic-chip

Rabin Vincent (1):
      gpio/nomadik: disable clocks when unused

Rob Herring (1):
      gpio: pl061: add DT binding support

Shawn Guo (1):
      gpio/mxc: add chained_irq_enter/exit() to mx3_gpio_irq_handler()

Tomoya MORINAGA (11):
      gpio-ml-ioh: Delete unnecessary code
      gpio-ml-ioh: Support interrupt function
      gpio-ml-ioh: Fix suspend/resume issue
      gpio-pch: Delete invalid "restore" code in suspend()
      gpio-pch: add spinlock in suspend/resume processing
      gpio-pch: support ML7223 IOH n-Bus
      gpio-pch: modify gpio_nums and mask
      gpio-pch: Save register value in suspend()
      gpio-pch: Support interrupt function
      gpio-pch: Use NUMA_NO_NODE not GFP_KERNEL
      gpio-ml-ioh: Use NUMA_NO_NODE not GFP_KERNEL

 arch/arm/plat-nomadik/include/plat/gpio.h          |    3 +
 arch/h8300/include/asm/{gpio.h => gpio-internal.h} |    0
 arch/h8300/platform/h8300h/irq.c                   |    2 +-
 arch/h8300/platform/h8s/irq.c                      |    2 +-
 drivers/gpio/Kconfig                               |    2 +
 drivers/gpio/gpio-langwell.c                       |   27 ++
 drivers/gpio/gpio-ml-ioh.c                         |  254 +++++++++++++++++++-
 drivers/gpio/gpio-mxc.c                            |    6 +
 drivers/gpio/gpio-nomadik.c                        |  127 +++++++++-
 drivers/gpio/gpio-pch.c                            |  250 +++++++++++++++++++-
 drivers/gpio/gpio-pl061.c                          |   31 ++-
 include/asm-generic/gpio.h                         |   17 +-
 include/linux/amba/pl061.h                         |    3 +-
 include/linux/gpio.h                               |   22 +-
 kernel/irq/generic-chip.c                          |    4 +
 15 files changed, 683 insertions(+), 67 deletions(-)
 rename arch/h8300/include/asm/{gpio.h => gpio-internal.h} (100%)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
