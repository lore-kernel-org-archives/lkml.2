Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1F2JED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:04:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48954 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1F2JDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:03:40 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Matthias Kaehlcke <matthias@kaehlcke.net>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH v2] implement a generic PWM framework
Date: Wed, 29 Jun 2011 11:03:33 +0200
Message-Id: <1309338215-10702-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.5.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments to the last version, hopefully I addressed
them all. Here is another round of the patches.

changes since last version:

- only kfree() in case of errors
- add missing kfree() in pwmchip_remove()
- drop dynamic pwm id support
- fix typos, remove unused variables
- instantiate pwm_base_common in mxs-pwm driver from resources

The following changes since commit b0af8dfdd67699e25083478c63eedef2e72ebd85:

  Linux 3.0-rc5 (2011-06-27 19:12:22 -0700)

are available in the git repository at:
  git://git.pengutronix.de/git/imx/linux-2.6.git pwm

Sascha Hauer (2):
      PWM: add pwm framework support
      pwm: Add a i.MX23/28 pwm driver

 Documentation/pwm.txt |   56 +++++++++
 MAINTAINERS           |    5 +
 drivers/Kconfig       |    2 +
 drivers/Makefile      |    1 +
 drivers/pwm/Kconfig   |   16 +++
 drivers/pwm/Makefile  |    2 +
 drivers/pwm/core.c    |  220 +++++++++++++++++++++++++++++++++
 drivers/pwm/mxs-pwm.c |  321 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm.h   |   37 ++++++
 9 files changed, 660 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/core.c
 create mode 100644 drivers/pwm/mxs-pwm.c

