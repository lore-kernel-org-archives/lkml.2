Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2DMWur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:50:47 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:33183 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756248Ab2DMWup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:50:45 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be, jonsmirl@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND v3 0/8] arm: lpc32xx: Device tree support
Date: Sat, 14 Apr 2012 00:49:57 +0200
Message-Id: <1334357397-21296-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first series of patches to introduce device tree support for the
LPC32xx SoC. This series includes patches for the various subsystems to support
device tree to be used later by the machine's initialization.

The patches apply to various subsystems:

 * staging/iio/adc (1)
 * rtc (1)
 * net (1) - to be merged via arm-soc, acked by davem
 * wdt (1)
 * i2c (4)
 * arm-soc (i2c related in the former, to be merged via i2c, as suggested by
	    Arnd Bergmann)

Applies to v3.4-rc2

You can also pull from

  git://git.antcom.de/linux-2.6 lpc32xx/dt

I'm CC'ing the various subsystem maintainers and lists who can each see what's
going on and please pick their respective subsystem's changes. - Thanks!

Changes since patch v2:
 * net: Use of_property_read_bool()
 * net: Fixed breakage with non-DT board (iram and mii options)

Signed-off-by: Roland Stigge <stigge@antcom.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

--

Roland Stigge (8):
 iio: Add device tree support to LPC32xx ADC
 rtc: Add device tree support for LPC32xx
 net: Add device tree support to LPC32xx
 wdt: Device tree support for pnx4008-wdt
 i2c-pnx.c: Fix suspend
 i2c-pnx.c: Use resources in platforms
 i2c-pnx.c: Remove duplicated i2c.h
 i2c: Add device tree support to i2c-pnx.c

 Documentation/devicetree/bindings/i2c/pnx.txt                     |   40 ++
 Documentation/devicetree/bindings/net/lpc-eth.txt                 |   24 +
 Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt             |   15 
 Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt |   16 
 Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt        |   13 
 arch/arm/mach-lpc32xx/common.c                                    |   75 ++--
 arch/arm/mach-lpc32xx/include/mach/i2c.h                          |   63 ---
 arch/arm/mach-pnx4008/i2c.c                                       |   64 ++-
 arch/arm/mach-pnx4008/include/mach/i2c.h                          |   64 ---
 drivers/i2c/busses/i2c-pnx.c                                      |  164 +++++++---
 drivers/net/ethernet/nxp/lpc_eth.c                                |   73 ++--
 drivers/rtc/rtc-lpc32xx.c                                         |   12 
 drivers/staging/iio/adc/lpc32xx_adc.c                             |   10 
 drivers/watchdog/pnx4008_wdt.c                                    |   10 
 include/linux/i2c-pnx.h                                           |   10 
 15 files changed, 512 insertions(+), 268 deletions(-)
