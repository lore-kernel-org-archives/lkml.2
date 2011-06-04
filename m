Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1FDKrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 06:47:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51238 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1FDKrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 06:47:17 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: [PATCH v3 0/3] Move Freescale MXS gpio driver into drivers/gpio
Date: Sat,  4 Jun 2011 18:55:37 +0800
Message-Id: <1307184940-16291-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set moves Freescale MXS gpio driver from mach-mxs into
drivers/gpio.

Changes since v2:
* Add a patch as the first one just copying mach-mxs gpio into
  drivers/gpio
* Add the missing ".owner = THIS_MOUDLE" for gpio-mxs driver

Shawn Guo (3):
      gpio: gpio-mxs: copy mach-mxs/gpio.c into drivers/gpio
      gpio: gpio-mxs: make it work for Freescale MXS architecture
      ARM: mxs: use gpio-mxs driver by adding platform device

 arch/arm/mach-mxs/Makefile                         |    2 +-
 arch/arm/mach-mxs/devices.c                        |   11 +
 arch/arm/mach-mxs/devices/Makefile                 |    1 +
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c      |   53 +++++
 arch/arm/mach-mxs/gpio.h                           |   34 ---
 arch/arm/mach-mxs/include/mach/devices-common.h    |    2 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |    1 -
 arch/arm/mach-mxs/mm-mx23.c                        |    1 -
 arch/arm/mach-mxs/mm-mx28.c                        |    1 -
 drivers/gpio/Makefile                              |    1 +
 .../arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c |  227 ++++++++++++--------
 11 files changed, 202 insertions(+), 132 deletions(-)
