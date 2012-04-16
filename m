Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2DPJVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:21:23 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:9105 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab2DPJVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 00/12] at91: 3.4-rc3 fixes
Date: Mon, 16 Apr 2012 11:20:44 +0200
Message-Id: <cover.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is another fixes series for AT91 that will go on top of 3.4-rc3.
We experienced some issues while compiling some drivers as modules: Joachim has
corrected several of them. We may reduce this number of exported values by
reworking some drivers, in the future.
Some drivers are also modified here, I would like to keep them in the series
as the modifications are really related with our recent move to irqdomains or
simply related with compiler annotations.

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
  ARM: at91/atmel-mci: remove unused setup_dma_addr() macro
  leds-atmel-pwm.c: Make pwmled_probe() __devinit
  USB: ohci-at91: change annotations for probe/remove functions
  USB: gadget/at91_udc: add gpio_to_irq() function to vbus interrupt

 arch/arm/mach-at91/at91rm9200_devices.c     |    1 -
 arch/arm/mach-at91/at91rm9200_time.c        |    2 ++
 arch/arm/mach-at91/board-rm9200ek.c         |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c        |    5 +++--
 arch/arm/mach-at91/clock.c                  |    1 +
 arch/arm/mach-at91/include/mach/at91_pmc.h  |    2 +-
 arch/arm/mach-at91/include/mach/atmel-mci.h |    7 -------
 arch/arm/mach-at91/setup.c                  |    2 ++
 drivers/leds/leds-atmel-pwm.c               |    2 +-
 drivers/usb/gadget/at91_udc.c               |    8 ++++----
 drivers/usb/host/ohci-at91.c                |   12 ++++++------
 11 files changed, 21 insertions(+), 23 deletions(-)

Thanks, best regards,
-- 
1.7.10

