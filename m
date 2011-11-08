Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1KHOPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:15:48 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:38725 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab1KHOPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:15:43 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <cover.1320753142.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Tue, 8 Nov 2011 12:52:22 +0100
Subject: [PATCH V3 0/4] AT91: replace broken TWI driver i2c-at91.c
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

V3: Integrated review comments from Ryan Mallon and Felipe Balbi
V2: Fixed whitespace issue

Nikolaus Voss (4):
  drivers/i2c/busses/i2c-at91.c: remove broken driver
  drivers/i2c/busses/i2c-at91.c: add new driver
  G45 TWI: remove open drain setting for twi function gpios
  Add lookup entries for twi_clk for devices with more than one TWI
    port

 arch/arm/mach-at91/at91sam9g45.c         |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c |    6 -
 arch/arm/mach-at91/at91sam9rl.c          |    2 +
 drivers/i2c/busses/Kconfig               |   11 +-
 drivers/i2c/busses/i2c-at91.c            |  453 +++++++++++++++++++-----------
 5 files changed, 292 insertions(+), 182 deletions(-)

-- 
1.7.5.4

