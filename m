Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab2H2ILG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:11:06 -0400
Received: from mail.steuer-voss.com ([85.183.17.159]:42008 "EHLO
	mail.steuer-voss.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752801Ab2H2ILA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:11:00 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2012 04:11:00 EDT
Message-Id: <cover.1346225321.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Wed, 29 Aug 2012 09:28:41 +0200
Subject: [PATCH v11 0/4] AT91: replace old i2c-at91.c TWI driver
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Cc: nicolas.ferre@atmel.com, ben-linux@fluff.org, balbi@ti.com,
        h.feurstein@gmail.com, rmallon@gmail.com, adrian.yanes@aalto.fi,
        ludovic.desroches@atmel.com, carsten.behling@garz-fricke.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old driver has two main deficencies:
i)  No repeated start (Sr) condiction is possible, this makes it unusable
    e.g. for most SMBus transfers.
ii) I/O was done with polling/busy waiting what caused over-/underruns
    even at light system loads and clock speeds.

The new driver overcomes these deficencies and in addition allows for
more than one TWI interface.

A remaining limitation is the fact, that only one repeated start is
possible (two concatenated messages). This limitation is imposed by
the hardware. However, this should not be a problem as all common
i2c-client communication does not rely on more than one repeated start.

Changes since v11:
- corrected wrong id_entry on sam9261 twi gpio pdev

Nikolaus Voss (4):
  drivers/i2c/busses/i2c-at91.c: remove old polling driver
  Replace clk_lookup.con_id with clk_lookup.dev_id entries for twi clk
  drivers/i2c/busses/i2c-at91.c: add new driver
  G45 TWI: remove open drain setting for twi function gpios

 arch/arm/mach-at91/at91rm9200.c            |    1 +
 arch/arm/mach-at91/at91rm9200_devices.c    |    9 +
 arch/arm/mach-at91/at91sam9260.c           |    1 +
 arch/arm/mach-at91/at91sam9261.c           |    1 +
 arch/arm/mach-at91/at91sam9261_devices.c   |    9 +
 arch/arm/mach-at91/at91sam9263.c           |    1 +
 arch/arm/mach-at91/at91sam9g45.c           |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c   |    6 -
 arch/arm/mach-at91/at91sam9rl.c            |    2 +
 arch/arm/mach-at91/at91sam9x5.c            |    3 +
 arch/arm/mach-at91/include/mach/at91_twi.h |   68 ----
 drivers/i2c/busses/Kconfig                 |   11 +-
 drivers/i2c/busses/i2c-at91.c              |  591 ++++++++++++++++++----------
 13 files changed, 418 insertions(+), 287 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_twi.h

-- 
1.7.9.5

