Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2DBM54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:57:56 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:48020 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751732Ab2DBM5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:57:54 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 0/7]: arm: lpc32xx: Device tree support
Date: Mon,  2 Apr 2012 14:55:57 +0200
Message-Id: <1333371364-21347-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first series of patches to introduce device tree support for the
LPC32xx SoC. This series includes patches for the various subsystems to support
device tree to be used later by the machine's initialization.

The patches apply to various subsystems:

 * staging/iio/adc
 * rtc
 * net
 * arm-soc
 * i2c
 * wdt

Based on v3.4-rc1

You can also pull from

  git://git.antcom.de/linux-2.6 lpc32xx/dt

I'm CC'ing the various subsystem maintainers and lists who can each see what's
going on and please pick their respective subsystem's changes. - Thanks!

Signed-off-by: Roland Stigge <stigge@antcom.de>

--

Roland Stigge (7):
 iio: Add device tree support to LPC32xx ADC
 rtc: Add device tree support for LPC32xx
 net: Add device tree support to LPC32xx
 arm: mach-pnx4008: Adjust i2c.c to updated i2c-pnx.c
 i2c: Add device tree support to i2c-pnx.c
 i2c-pnx.c: Fix suspend
 wdt: Device tree support for pnx4008-wdt

 Documentation/devicetree/bindings/i2c/pnx.txt                     |   36 ++
 Documentation/devicetree/bindings/net/lpc-eth.txt                 |   25 +
 Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt             |   15 
 Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt |   16 
 Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt        |   13 
 arch/arm/mach-pnx4008/i2c.c                                       |   58 ++-
 arch/arm/mach-pnx4008/include/mach/i2c.h                          |   64 ---
 drivers/i2c/busses/i2c-pnx.c                                      |  163 +++++++---
 drivers/net/ethernet/nxp/lpc_eth.c                                |   76 ++--
 drivers/rtc/rtc-lpc32xx.c                                         |   12 
 drivers/staging/iio/adc/lpc32xx_adc.c                             |   10 
 drivers/watchdog/pnx4008_wdt.c                                    |   10 
 include/linux/i2c-pnx.h                                           |   10 
 13 files changed, 340 insertions(+), 168 deletions(-)
