Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1E1PCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:02:01 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:43229 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab1E1PCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:02:00 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: [PATCH v2 0/2] Move Freescale MXS gpio driver into drivers/gpio
Date: Sat, 28 May 2011 23:09:32 +0800
Message-Id: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set moves Freescale MXS gpio driver from mach-mxs into
drivers/gpio.

Changes since v1:
 * Squash the 4 gpio-mxs patches into one
 * Do not add new gpio Kconfig option and use ARCH_MXS directly
 * Clean up platform-gpio-mxs.c per Arnd's comments
 * Add device mxs_apbh_bus and set it as the parent of gpio devices

Shawn Guo (2):
      gpio: gpio-mxs: add gpio driver for Freescale MXS architecture
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
 .../arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c |  228 ++++++++++++--------
