Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2G0MF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:05:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5668 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2G0MFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:05:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jul 2012 05:01:08 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC][PATCH v3 0/3] Power sequences with PWM and DT support
Date: Fri, 27 Jul 2012 21:05:47 +0900
Message-ID: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Widening audience for this version.

The issue addressed is that the power sequences for backlights (and probably
other devices), which were implemented using board-specific callbacks so far,
could not be used with the device tree. This series of patches adds a small
power sequence interpreter that allows to acquire and control regulators, GPIOs,
and PWMs during sequences defined in the device tree or as platform data. It is
easy to use, low-footprint, and takes care of managing the resources it
acquires. This should help making the kernel less board-dependant.

Comments are especially welcome about the DT bindings proposal, which most
certainly needs to be refined, if not completely redesigned. Documentation is
still incomplete and will consolidate once the implementation reaches a stable
state.

The tegra device tree nodes of patch 3 are just here as an example usage.

Changelog:

v3:
- Move to driver to base/
- Use sub-nodes to describe steps in the DT as suggested by Simon Glass
- Write some documentation
- Make the DT support optional

Alexandre Courbot (3):
  runtime interpreted power sequences
  pwm_backlight: use power sequences
  tegra: add pwm backlight device tree nodes

 .../bindings/video/backlight/pwm-backlight.txt     |  55 +++-
 Documentation/power/power_seq.txt                  | 120 +++++++++
 arch/arm/boot/dts/tegra20-ventana.dts              |  53 ++++
 arch/arm/boot/dts/tegra20.dtsi                     |   2 +-
 drivers/base/Kconfig                               |   4 +
 drivers/base/Makefile                              |   1 +
 drivers/base/power_seq.c                           | 300 +++++++++++++++++++++
 drivers/video/backlight/Kconfig                    |   1 +
 drivers/video/backlight/pwm_bl.c                   | 213 +++++++++++----
 include/linux/power_seq.h                          | 139 ++++++++++
 include/linux/pwm_backlight.h                      |  18 +-
 11 files changed, 843 insertions(+), 63 deletions(-)
 create mode 100644 Documentation/power/power_seq.txt
 create mode 100644 drivers/base/power_seq.c
 create mode 100644 include/linux/power_seq.h

-- 
1.7.11.3

