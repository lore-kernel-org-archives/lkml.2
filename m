Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2DQPDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:03:11 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:48134 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab2DQPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:03:10 -0400
Message-ID: <4F8D860C.8040306@atmel.com>
Date: Tue, 17 Apr 2012 17:02:36 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Joachim Eastwood <joachim.eastwood@jotron.com>
Subject: [GIT PULL] at91: 3.4-rc3 fixes
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, Olof,

This is a new fixes series for AT91. I have tried to make it as a
signed tag...


The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to f898fed0c27b2d46c3d8331e7825c25b6432b9f4:

  dmaengine: Kconfig: fix Atmel at_hdmac entry (2012-04-17 16:29:41 +0200)

----------------------------------------------------------------
Here is another fixes series for AT91 designed for 3.4-rc.
We experienced some issues while compiling some drivers as modules: Joachim has
corrected several of them. We may reduce this number of exported values by
reworking some drivers, in the future.
Some drivers are also modified here, I would like to keep them in the series
as the modifications are really related with our recent move to irqdomains or
simply related with compiler annotations.
I keep dmaengine Kconfig modification in this "fixes" series. The DMA
driver will not be available for 9x5 SoC family otherwise.

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (2):
      ARM: at91: fix rm9200ek flash size
      ARM: at91: fix at91sam9261ek Ethernet dm9000 irq

Joachim Eastwood (5):
      ARM: at91: Export at91_st_base
      ARM: at91: Export at91_ramc_base
      ARM: at91: Export at91_pmc_base
      ARM: at91: Export at91_matrix_base
      ARM: at91: remove empty at91_init_serial function

Nicolas Ferre (5):
      ARM: at91: fix typo in at91_pmc_base assembly declaration
      leds-atmel-pwm.c: Make pwmled_probe() __devinit
      USB: ohci-at91: change annotations for probe/remove functions
      USB: gadget/at91_udc: add gpio_to_irq() function to vbus interrupt
      dmaengine: Kconfig: fix Atmel at_hdmac entry

 arch/arm/mach-at91/at91rm9200_devices.c    |    1 -
 arch/arm/mach-at91/at91rm9200_time.c       |    2 ++
 arch/arm/mach-at91/board-rm9200ek.c        |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c       |    5 +++--
 arch/arm/mach-at91/clock.c                 |    1 +
 arch/arm/mach-at91/include/mach/at91_pmc.h |    2 +-
 arch/arm/mach-at91/setup.c                 |    2 ++
 drivers/dma/Kconfig                        |    5 ++---
 drivers/leds/leds-atmel-pwm.c              |    2 +-
 drivers/usb/gadget/at91_udc.c              |    8 ++++----
 drivers/usb/host/ohci-at91.c               |   12 ++++++------
 11 files changed, 23 insertions(+), 19 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre
