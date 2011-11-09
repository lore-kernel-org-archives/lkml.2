Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1KIQGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:06:04 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:36545 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab1KIQGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:06:02 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <cover.1320853921.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Wed, 9 Nov 2011 16:52:01 +0100
Subject: [PATCH v4 0/4] AT91: replace broken TWI driver i2c-at91.c
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, khali@linux-fr.org, nicolas.ferre@atmel.com,
        rmallon@gmail.com, balbi@ti.com
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

v4: Integrated more review comments from Ryan Mallon and Felipe Balbi:
    Moved register include file to local include, code cleanups
v3: Integrated review comments from Ryan Mallon and Felipe Balbi
v2: Fixed whitespace issue

Nikolaus Voss (4):
  drivers/i2c/busses/i2c-at91.c: remove broken driver
  drivers/i2c/busses/i2c-at91.c: add new driver
  G45 TWI: remove open drain setting for twi function gpios
  Add lookup entries for twi_clk for devices with more than one TWI
    port

 arch/arm/mach-at91/at91sam9g45.c           |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c   |    6 -
 arch/arm/mach-at91/at91sam9rl.c            |    2 +
 arch/arm/mach-at91/include/mach/at91_twi.h |   68 ----
 drivers/i2c/busses/Kconfig                 |   11 +-
 drivers/i2c/busses/i2c-at91.c              |  476 +++++++++++++++++-----------
 drivers/i2c/busses/i2c-at91.h              |   80 +++++
 7 files changed, 371 insertions(+), 274 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_twi.h
 create mode 100644 drivers/i2c/busses/i2c-at91.h

-- 
1.7.5.4

