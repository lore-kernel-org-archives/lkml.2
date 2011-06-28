Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1F1KEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:04:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab1F1KC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:02:56 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: [RFC] implement a generic PWM framework - once again
Date: Tue, 28 Jun 2011 12:02:46 +0200
Message-Id: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.5.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following implements a generic pwm framework and adds a user
for it. I already posted this series back in January. Based on
the comments I received I added some details about the motivation
for adding such a framework and not using the led or hwmon framework
to patch 1/2.
I also added some documentation to Documentation/pwm.txt.

This patch does not change the user API for PWMs, in particular
it does not enforce any sleep/nonsleep context to the PWM users.
The patch merely puts the status quo into a core wrapper to be able
to register multiple PWM drivers in the system. Improvements to
the API can still be made later once we have at least a place
in the kernel to collect the existing PWM drivers.

Sascha

The following changes since commit b0af8dfdd67699e25083478c63eedef2e72ebd85:

  Linux 3.0-rc5 (2011-06-27 19:12:22 -0700)

are available in the git repository at:
  git://git.pengutronix.de/git/imx/linux-2.6.git pwm

Sascha Hauer (2):
      PWM: add pwm framework support
      pwm: Add a i.MX23/28 pwm driver

 Documentation/pwm.txt |   56 ++++++++++
 MAINTAINERS           |    5 +
 drivers/Kconfig       |    2 +
 drivers/Makefile      |    1 +
 drivers/pwm/Kconfig   |   12 ++
 drivers/pwm/Makefile  |    1 +
 drivers/pwm/core.c    |  246 +++++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/mxs-pwm.c |  275 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm.h   |   38 +++++++
 9 files changed, 636 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/core.c
 create mode 100644 drivers/pwm/mxs-pwm.c

