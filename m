Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2GIGHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:07:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11872 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2GIGHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:07:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 08 Jul 2012 23:07:16 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC][PATCHv2 0/3] Power sequences interpreter for pwm_backlight
Date: Mon, 9 Jul 2012 15:08:22 +0900
Message-ID: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC since this patch largely drifted beyond its original goal
of supporting one GPIO and one regulator for the pwm_backlight driver.

The issue to address is that backlight power sequences, which were
implemented using board-specific callbacks so far, could not be used with
the device tree. This series of patches adds a small power sequence 
interpreter that allows to acquire and control regulators, GPIOs, and PWMs
during sequences defined in the device tree. It is easy to use,
low-footprint, and takes care of managing the resources that it acquires.

The implementation is working and should be complete, but documentation is
lacking. Also since the interpreter could be used by other drivers (which
ones?), it may make sense to have it in a better place than
drivers/video/backlight/.

The tegra device tree nodes are just here as an example usage.

Alexandre Courbot (3):
  Power sequences interpreter for device tree
  pwm-backlight: use power sequences
  tegra: add pwm backlight device tree nodes

 .../bindings/video/backlight/pwm-backlight.txt     |  28 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |  31 +++
 arch/arm/boot/dts/tegra20.dtsi                     |   2 +-
 drivers/video/backlight/Makefile                   |   2 +-
 drivers/video/backlight/power_seq.c                | 298 +++++++++++++++++++++
 drivers/video/backlight/pwm_bl.c                   | 212 +++++++++++----
 include/linux/power_seq.h                          |  96 +++++++
 include/linux/pwm_backlight.h                      |  37 ++-
 8 files changed, 645 insertions(+), 61 deletions(-)
 create mode 100644 drivers/video/backlight/power_seq.c
 create mode 100644 include/linux/power_seq.h

-- 
1.7.11.1

