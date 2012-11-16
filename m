Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab2KPGin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:38:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12928 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2KPGil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:38:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 15 Nov 2012 22:38:40 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <l.krishna@samsung.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v8 0/3] Runtime Interpreted Power Sequences
Date: Fri, 16 Nov 2012 15:38:20 +0900
Message-ID: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully the final series before the feature gets merged. Anton Vorontsov
kindly accepted to take it into his tree, so this series is mostly a call for
acks, tests and reviews notices before the merge window for 3.8 opens. If you
are interested in seeing this feature, please add your name.

This series also adds an entry for the subsystem into MAINTAINERS, setting me as
the person in charge.

Changes from v7:
- fix bug reported by Tony Prisk
- add MAINTAINERS entry

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
 drivers/power/power_seq/Makefile                   |   1 +
 drivers/power/power_seq/power_seq.c                | 376 +++++++++++++++++++++
 drivers/power/power_seq/power_seq_delay.c          |  65 ++++
 drivers/power/power_seq/power_seq_gpio.c           |  94 ++++++
 drivers/power/power_seq/power_seq_pwm.c            |  82 +++++
 drivers/power/power_seq/power_seq_regulator.c      |  83 +++++
 drivers/video/backlight/Kconfig                    |   1 +
 drivers/video/backlight/pwm_bl.c                   | 160 +++++++--
 include/linux/power_seq.h                          | 203 +++++++++++
 include/linux/pwm_backlight.h                      |  18 +-
 17 files changed, 1494 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power_seq.txt
 create mode 100644 Documentation/power/power_seq.txt
 create mode 100644 drivers/power/power_seq/Kconfig
 create mode 100644 drivers/power/power_seq/Makefile
 create mode 100644 drivers/power/power_seq/power_seq.c
 create mode 100644 drivers/power/power_seq/power_seq_delay.c
 create mode 100644 drivers/power/power_seq/power_seq_gpio.c
 create mode 100644 drivers/power/power_seq/power_seq_pwm.c
 create mode 100644 drivers/power/power_seq/power_seq_regulator.c
 create mode 100644 include/linux/power_seq.h

-- 
1.8.0

