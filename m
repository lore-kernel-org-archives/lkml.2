Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab1FWMNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:13:13 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:43170 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757947Ab1FWMNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:13:09 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Fredrik Svensson <fredrik.xk.svensson@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH 0/4] Nomadik GPIO patches for 3.1, round 1
Date: Thu, 23 Jun 2011 14:11:52 +0200
Message-ID: <1308831112-10250-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is the pending Nomadik GPIO patches up until I start to muck
around with the generic configuration mechanism, it'd be nice to
get this into the GPIO tree as a base.

[1/4] moves the header file out of <plat/*> and into
<linux/gpio/nomadik.h> which is necessary for single kernel
support across multiple platforms, I don't know how many plats
would collide in <plat/gpio.h> if we don't do this. It's
the first of its kind and create this namespace so I
hope you like it.

[2/4] mainly mess with GPIO-related pinconfig, and need to
go through the GPIO or ux500 tree until we have a pinmux
subsystem. If you don't like it, I can take it into
the ux500 tree. (The rest apply cleanly anyway.)

[3/4] and [4/4] are straightforward improvements.

I expect to send another patch set for the generic config
mechanism once we have decided on a solution for that.

Fredrik Svensson (1):
  gpio/nomadik: remove pull-pinconfig and add SPI2

Linus Walleij (2):
  gpio/nomadik: move the Nomadik GPIO header
  gpio/nomadik: use genirq core to track enablement

Rabin Vincent (1):
  gpio/nomadik: disable clocks when unused

 arch/arm/mach-nomadik/board-nhk8815.c       |    1 +
 arch/arm/mach-nomadik/cpu-8815.c            |    1 +
 arch/arm/mach-nomadik/i2c-8815nhk.c         |    2 +-
 arch/arm/mach-nomadik/include/mach/gpio.h   |    8 ++-
 arch/arm/mach-ux500/board-mop500-pins.c     |    2 +-
 arch/arm/mach-ux500/board-mop500-sdi.c      |    1 +
 arch/arm/mach-ux500/board-u5500-sdi.c       |    2 +-
 arch/arm/mach-ux500/cpu-db5500.c            |    3 +-
 arch/arm/mach-ux500/cpu-db8500.c            |    5 +-
 arch/arm/mach-ux500/devices-common.c        |    3 +-
 arch/arm/mach-ux500/include/mach/gpio.h     |    8 ++-
 arch/arm/mach-ux500/pins-db8500.h           |  142 ++++++++++++++-------------
 arch/arm/plat-nomadik/include/plat/gpio.h   |   96 ------------------
 arch/arm/plat-nomadik/include/plat/pincfg.h |    5 -
 drivers/gpio/gpio-nomadik.c                 |  129 +++++++++++++++++++++---
 include/linux/gpio/nomadik.h                |   87 ++++++++++++++++
 16 files changed, 300 insertions(+), 195 deletions(-)
 delete mode 100644 arch/arm/plat-nomadik/include/plat/gpio.h
 create mode 100644 include/linux/gpio/nomadik.h

-- 
1.7.3.2

