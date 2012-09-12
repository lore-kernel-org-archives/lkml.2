Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab2ILJ4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:56:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18628 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab2ILJ4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:56:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 12 Sep 2012 02:48:18 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <l.krishna@samsung.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v6 0/4] Runtime Interpreted Power Sequences
Date: Wed, 12 Sep 2012 18:57:43 +0900
Message-ID: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.12
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New revision of the power sequences, taking as usual the feedback that was
kindly provided about the last version.

I think now is a good time to discuss integrating this and to start looking for
a maintainer who would be willing to merge this into his/her tree (I am
especially thinking about the power framework maintainers, since this is where
the code is right now. The second patch in this series enables the pwm_backlight
driver to be used with the device tree, without relying on board-dependent
callbacks to support complex power sequences. We also plan to use power
sequences in other Tegra drivers, and other people have expressed interest in
this work during earlier reviews. See for instance

https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-August/018532.html

and

https://lkml.org/lkml/2012/9/6/270

There is probably some more details to fix and improve, but the current shape
should be enough to know if we want this and where - therefore any sign from
a maintainer would be greatly appreciated!

Changes since v5:
* Removed pointers to platform data from resource structure for better code
  clarity
* devm_power_seq_set_build() now automatically checks the DT if no platform
  data is present, making it possible to remove the explicit DT parsing function
* Lots of fixes in the documentation which should be clearer now (thanks
  Stephen!)

Alexandre Courbot (4):
  Runtime Interpreted Power Sequences
  pwm_backlight: use power sequences
  tegra: dt: add label to tegra20's PWM
  tegra: ventana: add pwm backlight DT nodes

 .../devicetree/bindings/power_seq/power_seq.txt    | 122 ++++++
 .../bindings/video/backlight/pwm-backlight.txt     |  65 ++-
 Documentation/power/power_seq.txt                  | 215 ++++++++++
 arch/arm/boot/dts/tegra20-ventana.dts              |  59 ++-
 arch/arm/boot/dts/tegra20.dtsi                     |   2 +-
 drivers/power/Kconfig                              |   1 +
 drivers/power/Makefile                             |   1 +
 drivers/power/power_seq/Kconfig                    |   2 +
 drivers/power/power_seq/Makefile                   |   1 +
 drivers/power/power_seq/power_seq.c                | 446 +++++++++++++++++++++
 drivers/power/power_seq/power_seq_delay.c          |  51 +++
 drivers/power/power_seq/power_seq_gpio.c           |  91 +++++
 drivers/power/power_seq/power_seq_pwm.c            |  87 ++++
 drivers/power/power_seq/power_seq_regulator.c      |  87 ++++
 drivers/video/backlight/Kconfig                    |   1 +
 drivers/video/backlight/pwm_bl.c                   | 180 ++++++---
 include/linux/power_seq.h                          | 172 ++++++++
 include/linux/pwm_backlight.h                      |  15 +-
 18 files changed, 1543 insertions(+), 55 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_seq/power_seq.txt
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
1.7.12

