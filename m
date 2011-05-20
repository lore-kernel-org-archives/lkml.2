Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1ETWF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:05:57 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:38005 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757241Ab1ETWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:05:45 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/4] Move U300 and Nomadik GPIO drivers
Date: Sat, 21 May 2011 00:05:00 +0200
Message-ID: <1305929100-9012-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This simply moves the U300 and Nomadik GPIO drivers to the
GPIO subsystem and applies debugfs additions and two new calls
on the Nomadik driver.

These patches were split out of an earlier GPIO consolidation
patch set and have all been reviewed in earlier incarnations.

Feel free to drop the two latter patches if you just want to do
the move in this merge window.

The drivers/gpio/Makefile will likely conflict with one or
another update, enjoy.

Linus Walleij (2):
  gpio: move U300 GPIO driver to drivers/gpio
  gpio: move Nomadik GPIO driver to drivers/gpio

Rabin Vincent (1):
  gpio/nomadik: show all pins in debug

Rickard Andersson (1):
  gpio/nomadik: add function to read GPIO pull down status

 arch/arm/mach-u300/Makefile               |    2 +-
 arch/arm/mach-u300/gpio.c                 |  700 -------------------
 arch/arm/plat-nomadik/Kconfig             |    5 -
 arch/arm/plat-nomadik/Makefile            |    1 -
 arch/arm/plat-nomadik/gpio.c              | 1024 ---------------------------
 arch/arm/plat-nomadik/include/plat/gpio.h |    2 +
 drivers/gpio/Makefile                     |    2 +
 drivers/gpio/gpio-nomadik.c               | 1073 +++++++++++++++++++++++++++++
 drivers/gpio/gpio-u300.c                  |  700 +++++++++++++++++++
 9 files changed, 1778 insertions(+), 1731 deletions(-)
 delete mode 100644 arch/arm/mach-u300/gpio.c
 delete mode 100644 arch/arm/plat-nomadik/gpio.c
 create mode 100644 drivers/gpio/gpio-nomadik.c
 create mode 100644 drivers/gpio/gpio-u300.c

-- 
1.7.3.2

