Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab2HaLcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:32:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5644 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2HaLcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:32:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 31 Aug 2012 04:26:02 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 0/4] Runtime Interpreted Power Sequences
Date: Fri, 31 Aug 2012 20:34:02 +0900
Message-ID: <1346412846-17102-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.12
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New revision taking (hopefully) all the feedback received from the previous
version into account. It's funny how a 30 lines patch to switch my backlight
turned into a 1500 lines patchset introducing a new framework. And in the end
my backlight switches just the same.

So anyway, the main updates are:

* Types of DT steps are now determined by a "type" property and not by the
  presence of a specific property.
* Power sequences and their resources are now encapsulated into a "set"
  structure. I was reluctant to this idea but have to admit now that it is way
  cleaner.
* GPIO steps now refer the GPIO phandle directly in the DT instead of by name.
  The GPIO framework does not work like regulator or PWM in that GPIOs cannot be
  accessed by name, so it did not make sense anyway. And thanks to that we now
  have perfect matching between the platform data members and the DT properties,
  which makes everything more consistent.
* Moved the implementations of resources into their own file (directly included
  from the main file) and added an "ops" structure to abstract them. This
  clearly separates the framework from the resources implementations and should
  make it easier to add new resources types.

Alexandre Courbot (4):
  Runtime Interpreted Power Sequences
  pwm_backlight: use power sequences
  tegra: dt: add label to tegra20's PWM
  tegra: ventana: add pwm backlight DT nodes

 .../devicetree/bindings/power_seq/power_seq.txt    | 117 ++++++
 .../bindings/video/backlight/pwm-backlight.txt     |  67 +++-
 Documentation/power/power_seq.txt                  | 225 +++++++++++
 arch/arm/boot/dts/tegra20-ventana.dts              |  59 ++-
 arch/arm/boot/dts/tegra20.dtsi                     |   2 +-
 drivers/power/Kconfig                              |   1 +
 drivers/power/Makefile                             |   1 +
 drivers/power/power_seq/Kconfig                    |   2 +
 drivers/power/power_seq/Makefile                   |   1 +
 drivers/power/power_seq/power_seq.c                | 446 +++++++++++++++++++++
 drivers/power/power_seq/power_seq_delay.c          |  51 +++
 drivers/power/power_seq/power_seq_gpio.c           |  81 ++++
 drivers/power/power_seq/power_seq_pwm.c            |  85 ++++
 drivers/power/power_seq/power_seq_regulator.c      |  86 ++++
 drivers/video/backlight/Kconfig                    |   1 +
 drivers/video/backlight/pwm_bl.c                   | 179 ++++++---
 include/linux/power_seq.h                          | 174 ++++++++
 include/linux/pwm_backlight.h                      |  15 +-
 18 files changed, 1537 insertions(+), 56 deletions(-)
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

