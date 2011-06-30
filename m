Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1F3KmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 06:42:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58386 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1F3KmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 06:42:01 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: [PATCH v3] implement a generic PWM framework
Date: Thu, 30 Jun 2011 12:41:54 +0200
Message-Id: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.5.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3rd version. No changes to the core except that I added F: drivers/pwm/ to
MAINTAINERS. Arnd, I looked through the comments to the first series again
and this was the only thing I could find I forgot. You referred to three
things. Is there more I forgot?

What changed though is the mxs pwm driver. I now register a pwm core
device which handles the shared enable register as suggested by Arnd.

Sascha

The following changes since commit b0af8dfdd67699e25083478c63eedef2e72ebd85:

  Linux 3.0-rc5 (2011-06-27 19:12:22 -0700)

are available in the git repository at:
  git://git.pengutronix.de/git/imx/linux-2.6.git pwm

Sascha Hauer (3):
      PWM: add pwm framework support
      ARM mxs: adjust pwm resources to what the driver expects
      pwm: Add a i.MX23/28 pwm driver

 Documentation/pwm.txt                        |   56 +++++
 MAINTAINERS                                  |    6 +
 arch/arm/mach-mxs/devices/platform-mxs-pwm.c |   32 +++-
 drivers/Kconfig                              |    2 +
 drivers/Makefile                             |    1 +
 drivers/pwm/Kconfig                          |   16 ++
 drivers/pwm/Makefile                         |    2 +
 drivers/pwm/core.c                           |  220 ++++++++++++++++++
 drivers/pwm/mxs-pwm.c                        |  312 ++++++++++++++++++++++++++
 include/linux/pwm.h                          |   37 +++
 10 files changed, 681 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/core.c
 create mode 100644 drivers/pwm/mxs-pwm.c

