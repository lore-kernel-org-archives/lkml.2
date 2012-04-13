Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987Ab2DMAwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:52:11 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49384 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab2DMAwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:52:09 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH v6 0/3] TS-5500 platform support
Date: Thu, 12 Apr 2012 20:28:52 -0400
Message-Id: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patchset brings support for the Technologic Systems TS-5500 platform.
The code is rebased on v3.4-rc2.

The first patch adds support to hwmon for the Maxim MAX197 A/D converter,
which is embedded on the TS-5500 platform, as suggested by Guenter Roeck.

The second patch adds basic support for the platform.

The third patch adds support for the board GPIO interface.
According to comments from Alan Cox and Mark Brown, the driver has been
reworked to use libgpio and moved to the GPIO subsystem.

	-Vivien


Jerome Oufella (1):
  gpio: TS-5500 GPIO support

Vivien Didelot (2):
  hwmon: Maxim MAX197 support
  x86/platform: TS-5500 basic platform support

 Documentation/ABI/testing/sysfs-platform-ts5500 |   46 +++
 Documentation/hwmon/max197                      |   59 ++++
 MAINTAINERS                                     |    7 +
 arch/x86/Kconfig                                |    8 +
 arch/x86/include/asm/ts5500.h                   |   62 ++++
 arch/x86/platform/Makefile                      |    1 +
 arch/x86/platform/ts5500/Makefile               |    1 +
 arch/x86/platform/ts5500/ts5500.c               |  400 +++++++++++++++++++++++
 drivers/gpio/Kconfig                            |    7 +
 drivers/gpio/Makefile                           |    1 +
 drivers/gpio/gpio-ts5500.c                      |  347 ++++++++++++++++++++
 drivers/hwmon/Kconfig                           |    9 +
 drivers/hwmon/Makefile                          |    1 +
 drivers/hwmon/max197.c                          |  398 ++++++++++++++++++++++
 include/linux/max197.h                          |   20 ++
 15 files changed, 1367 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ts5500
 create mode 100644 Documentation/hwmon/max197
 create mode 100644 arch/x86/include/asm/ts5500.h
 create mode 100644 arch/x86/platform/ts5500/Makefile
 create mode 100644 arch/x86/platform/ts5500/ts5500.c
 create mode 100644 drivers/gpio/gpio-ts5500.c
 create mode 100644 drivers/hwmon/max197.c
 create mode 100644 include/linux/max197.h

-- 
1.7.9.2

