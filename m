Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2DWJOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:14:22 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:36123 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037Ab2DWJOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:14:20 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/9] ux500/Nomadik GPIO and pins update
Date: Mon, 23 Apr 2012 11:14:00 +0200
Message-ID: <1335172440-27470-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is basically an update and sync of Nomadik and ux500 GPIO
development.

If you wonder why I introduce a deviant pin configuration path
not using the pin config subsystem it is because I want to build
atop of this work which I know works. It will be switched over
to pinctrl in later patch sets on top of this.

This is *almost* orthogonal to other ux500 development, but
there *might* be conflicts with Lee Jones' Device Tree work,
so I will try to create a separate orthogonal ux500 GPIO branch
for this stuff.

Linus Walleij (4):
  gpio/nomadik: use typesafe __io_address()
  plat-nomadik: new sleep mode pincfg macros
  ARM: ux500: remove a bunch of internal pull-ups
  ARM: ux500: update pin handling

Rabin Vincent (5):
  gpio/nomadik: don't set SLPM to 1 for non-wakeup pins
  gpio/nomadik: cache [rf]w?imsc
  gpio/nomadik: fix spurious interrupts with SKE
  gpio/nomadik: support low EMI mode
  ARM: ux500: implement pin API

 arch/arm/mach-ux500/Makefile                      |    2 +-
 arch/arm/mach-ux500/board-mop500-pins.c           |  394 ++++++++++++++++-----
 arch/arm/mach-ux500/board-mop500.h                |    4 +
 arch/arm/mach-ux500/pins-db8500.h                 |   72 ++--
 arch/arm/mach-ux500/pins.c                        |   88 +++++
 arch/arm/mach-ux500/pins.h                        |   46 +++
 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h |    1 +
 arch/arm/plat-nomadik/include/plat/pincfg.h       |   19 +
 drivers/gpio/gpio-nomadik.c                       |  129 +++++--
 9 files changed, 591 insertions(+), 164 deletions(-)
 create mode 100644 arch/arm/mach-ux500/pins.c
 create mode 100644 arch/arm/mach-ux500/pins.h

-- 
1.7.9.2

