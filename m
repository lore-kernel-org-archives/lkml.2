Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2KQK4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 05:56:03 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46143 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2KQK4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 05:56:00 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCHv9 0/3] Runtime Interpreted Power Sequences
Date: Sat, 17 Nov 2012 19:55:44 +0900
Message-Id: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for sending two patchsets in two days - the main purpose
of this new revision is to add the linux-arm-kernel list to the
audience. A few suggestions from v8 have also been added.

Changelog from v8:
- Compile resource support into different compilation units
- Check that resource support is compiled in when resolving sequences
- Now compilable as a module
- Renamed source files to avoid repeated power_seq in their path
- Add linux-arm-kernel list to audience as suggested by Mark Rutland

Alexandre Courbot (3):
  Runtime Interpreted Power Sequences
  pwm_backlight: use power sequences
  Take maintainership of power sequences

 .../devicetree/bindings/power/power_seq.txt        | 121 +++++++
 .../bindings/video/backlight/pwm-backlight.txt     |  63 +++-
 Documentation/power/power_seq.txt                  | 253 ++++++++++++++
 MAINTAINERS                                        |  10 +
 drivers/power/Kconfig                              |   1 +
 drivers/power/Makefile                             |   1 +
 drivers/power/power_seq/Kconfig                    |   2 +
 drivers/power/power_seq/Makefile                   |   2 +
 drivers/power/power_seq/core.c                     | 362 +++++++++++++++++++++
 drivers/power/power_seq/delay.c                    |  66 ++++
 drivers/power/power_seq/gpio.c                     |  95 ++++++
 drivers/power/power_seq/power_seq_priv.h           |  56 ++++
 drivers/power/power_seq/pwm.c                      |  85 +++++
 drivers/power/power_seq/regulator.c                |  87 +++++
 drivers/video/backlight/Kconfig                    |   1 +
 drivers/video/backlight/pwm_bl.c                   | 160 +++++++--
 include/linux/power_seq.h                          | 203 ++++++++++++
 include/linux/pwm_backlight.h                      |  18 +-
 18 files changed, 1546 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power_seq.txt
 create mode 100644 Documentation/power/power_seq.txt
 create mode 100644 drivers/power/power_seq/Kconfig
 create mode 100644 drivers/power/power_seq/Makefile
 create mode 100644 drivers/power/power_seq/core.c
 create mode 100644 drivers/power/power_seq/delay.c
 create mode 100644 drivers/power/power_seq/gpio.c
 create mode 100644 drivers/power/power_seq/power_seq_priv.h
 create mode 100644 drivers/power/power_seq/pwm.c
 create mode 100644 drivers/power/power_seq/regulator.c
 create mode 100644 include/linux/power_seq.h

-- 
1.8.0

