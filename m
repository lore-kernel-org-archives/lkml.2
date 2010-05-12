Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0ELBih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:38:37 -0400
Received: from smtp-out-074.synserver.de ([212.40.180.74]:1041 "HELO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752253Ab0ELBif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:38:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 7659
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/3] pcf50633: Replace custom gpio api with gpiolib
Date: Wed, 12 May 2010 03:31:13 +0200
Message-Id: <1273627876-26922-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch series replaces the custom api in the pcf50633 gpio driver with
gpiolib. There is only one user of the custom api which can be safely removed.

Lars-Peter Clausen (3):
  gta02: Remove usage of pcf50633 gpio api
  MFD: pcf50633-gpio: Add gpiolib support
  MFD: pcf50633: Move pcf50633-gpio driver to the gpio drivers folder

 arch/arm/mach-s3c2440/Kconfig      |    1 -
 arch/arm/mach-s3c2440/mach-gta02.c |   12 +--
 drivers/gpio/Kconfig               |    7 +
 drivers/gpio/Makefile              |    1 +
 drivers/gpio/pcf50633-gpio.c       |  228 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |    7 -
 drivers/mfd/Makefile               |    1 -
 drivers/mfd/pcf50633-core.c        |    4 +-
 drivers/mfd/pcf50633-gpio.c        |  121 -------------------
 include/linux/mfd/pcf50633/core.h  |    4 +
 include/linux/mfd/pcf50633/gpio.h  |   61 +++++-----
 11 files changed, 277 insertions(+), 170 deletions(-)
 create mode 100644 drivers/gpio/pcf50633-gpio.c
 delete mode 100644 drivers/mfd/pcf50633-gpio.c

