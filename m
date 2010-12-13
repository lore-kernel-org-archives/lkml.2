Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0LMEDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:03:42 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:52376 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab0LMEDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:03:41 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH v2 0/8] mfd/tc35892: allow to support multiple variants
Date: Mon, 13 Dec 2010 09:33:10 +0530
Message-ID: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series allows multiple variants of the Toshiba
TC35892XBG port expander devices into the same mfd core driver.

Sundar Iyer (8):
  mach-ux500: deprecate spi support for ab8500
  mfd/tc35892: rename tc35892 header to tc3589x
  mfd/tc35892: rename tc35892 core driver to tc3589x
  mfd/tc3589x: rename tc35892 structs/registers to tc359x
  mfd/tc3589x: add block identifier for multiple child devices
  mfd/tc3589x: fix random interrupt misses
  mfd/tc3589x: undo gpio module reset during chip init
  mfd/tc3589x: add suspend/resume support

 arch/arm/mach-ux500/board-mop500.c |   49 +----
 drivers/gpio/Kconfig               |    8 +-
 drivers/gpio/Makefile              |    2 +-
 drivers/gpio/tc35892-gpio.c        |  389 ----------------------------------
 drivers/gpio/tc3589x-gpio.c        |  389 ++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |    6 +-
 drivers/mfd/Makefile               |    2 +-
 drivers/mfd/tc35892.c              |  345 ------------------------------
 drivers/mfd/tc3589x.c              |  407 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tc35892.h        |  136 ------------
 include/linux/mfd/tc3589x.h        |  143 +++++++++++++
 11 files changed, 955 insertions(+), 921 deletions(-)
 delete mode 100644 drivers/gpio/tc35892-gpio.c
 create mode 100644 drivers/gpio/tc3589x-gpio.c
 delete mode 100644 drivers/mfd/tc35892.c
 create mode 100644 drivers/mfd/tc3589x.c
 delete mode 100644 include/linux/mfd/tc35892.h
 create mode 100644 include/linux/mfd/tc3589x.h

-- 
1.7.2.dirty

