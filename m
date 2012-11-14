Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2KNHTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:19:34 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:9387 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2KNHTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:32 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 00/11] watchdog/at91sam9_wdt: use watchdog framework, support DT 
Date: Wed, 14 Nov 2012 15:15:58 +0800
Message-Id: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 14 Nov 2012 07:19:14.0400 (UTC) FILETIME=[59CA4E00:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

The patch series is intended to convert to use the watchdog framework,
and add support to device tree.
It has been tested on sam9m10g45ek, sam9g20ek, sam9263ek and sam9g25ek.

It is based on v3.7-rc5.

Best Regards
Wenyou Yang

Wenyou Yang (11):
  watchdog/at91sam9_wdt: remove the file_operations struct
  watchdog/at91sam9_wdt: change the at91wdt_private struct to the
    at91wdt_drvdata struct
  watchdog/at91sam9_wdt: change the wdt_read and wdt_write macro to the
    inline function
  watchdog/at91sam9_wdt: change "at91_wdt_settimeout" function name to
    "at91wdt_enable"
  watchdog/at91sam9_wdt: add to use the watchdog framework
  watchdog/at91sam9_wdt: change the timer function name
  watchdog/at91sam9_wdt: add nowayout helpers to Watchdog Timer Driver
    Kernel API
  watchdog/at91sam9_wdt: use module_platform_driver()
  watchdog/at91sam9_wdt: add support to device tree
  watchdog/at91sam9_wdt: using dev_info replaces pr_info, dev_crit
    repalces pr_crit
  ARM: dts: add the watchdog nodes for atmel SoC

 .../devicetree/bindings/watchdog/atmel-wdt.txt     |   14 +
 arch/arm/boot/dts/at91sam9260.dtsi                 |    6 +
 arch/arm/boot/dts/at91sam9263.dtsi                 |    6 +
 arch/arm/boot/dts/at91sam9263ek.dts                |    4 +
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |    4 +
 arch/arm/boot/dts/at91sam9g25ek.dts                |    4 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |    5 +
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |    4 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |    6 +
 arch/arm/boot/dts/at91sam9n12ek.dts                |    4 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |    6 +
 drivers/watchdog/Kconfig                           |    1 +
 drivers/watchdog/at91sam9_wdt.c                    |  294 ++++++++------------
 13 files changed, 185 insertions(+), 173 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/watchdog/atmel-wdt.txt

-- 
1.7.9.5

