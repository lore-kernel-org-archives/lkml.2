Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1A1MVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:21:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42034 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1A1MVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:21:32 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.miao@linaro.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hemanth V <hemanthv@ti.com>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: [RFC] add pwmlib support
Date: Fri, 28 Jan 2011 13:21:21 +0100
Message-Id: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While implementing just another pwm driver I thought it's time to implement
generic pwm support. The following series adds drivers/pwm/pwmlib.c and
a i.MX23/28 pwm driver which serves as a usage example for pwmlib. The
code is inspired by gpiolib support and tested using the backlight pwm
driver by Eric Miao.

Currently the pwm_request, pwm_add, pwm_remove and pwm_free operations are
protected with a single mutex wherea the pwm_enable, pwm_disable and
pwm_config operations are unlocked. It is assumed that the owners of the
pwm handle the serialization of the pwm accesses. This may not be enough, so
i'd like to discuss the locking (and type of locking) here.

I Cced the people working with PWMs in the kernel in the hope that they can
give input on what's missing / wrong in this implementation

Sascha


The following changes since commit 2b1caf6ed7b888c95a1909d343799672731651a5:

  Merge branch 'core-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-01-20 18:30:37 -0800)

are available in the git repository at:

  git://git.pengutronix.de/git/imx/linux-2.6.git pwmlib

Sascha Hauer (2):
      pwmlib: add pwm support
      pwm: Add a i.MX23/28 pwm driver

 drivers/Kconfig       |    2 +
 drivers/Makefile      |    1 +
 drivers/pwm/Kconfig   |   16 +++
 drivers/pwm/Makefile  |    3 +
 drivers/pwm/mxs-pwm.c |  275 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/pwmlib.c  |  246 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm.h   |   38 +++++++
 7 files changed, 581 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/mxs-pwm.c
 create mode 100644 drivers/pwm/pwmlib.c

