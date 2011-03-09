Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab1CIMCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:02:42 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:45061 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932113Ab1CIMCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:02:41 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Jonas Aberg <jonas.aberg@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/3] TP6105x core and regulator driver v2
Date: Wed, 9 Mar 2011 13:02:10 +0100
Message-ID: <1299672130-4669-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds an MFD device for handling the TPS61052 boost converter
used in audio.

Changes v1->v2:
- Only register the mfd cells that are actually going to be used
  in the core driver (Mark)
- Don't set deafault valies in any registers on startup of core nor
  regulator driver (Mark)
- Use voltage set/get selector APIs to simplify regulator code (Mark)
- Reorder initcall placements (Mark)
- Platform data only allows one voltage so don't mark the consumer
  as "changeable" (Mark)
- Remove mfd cells on exit from tps6105x core (self)
- Clear separation of core driver and regulator patch in the
  series (Jonas)
- Do not mark core driver experimental (Mark)
- De-parenthesize numerals in header file (Jonas)
- kmalloc rather than kzalloc core state holder (Jonas)
- Update copyright headers (Jonas, Lee)

If any of you guys are happy, acked/reviewed-by is appreciated.

Linus Walleij (3):
  mfd: add a core driver for TI TPS61050/TPS61052 chips v2
  regulator: add a subdriver for TI TPS6105x regulator portions v2
  mach-ux500: configure board for the TPS61052 regulator v2

 arch/arm/mach-ux500/Kconfig                   |    1 +
 arch/arm/mach-ux500/board-mop500-regulators.c |   25 +++
 arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
 arch/arm/mach-ux500/board-mop500.c            |   14 ++
 drivers/mfd/Kconfig                           |   11 +
 drivers/mfd/Makefile                          |    1 +
 drivers/mfd/tps6105x.c                        |  245 +++++++++++++++++++++++++
 drivers/regulator/Kconfig                     |    9 +
 drivers/regulator/Makefile                    |    2 +-
 drivers/regulator/tps6105x-regulator.c        |  195 ++++++++++++++++++++
 include/linux/mfd/tps6105x.h                  |  101 ++++++++++
 11 files changed, 604 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/tps6105x.c
 create mode 100644 drivers/regulator/tps6105x-regulator.c
 create mode 100644 include/linux/mfd/tps6105x.h

-- 
1.7.3.2

