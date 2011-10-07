Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab1JGFEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:04:24 -0400
Received: from [117.192.88.236] ([117.192.88.236]:43378 "EHLO manju-desktop"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750960Ab1JGFEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:04:23 -0400
To: linux-arm-kernel@lists.infradead.org
Date: Fri, 07 Oct 2011 10:33:05 +0500
Subject: [PATCH 0/5] Driver Probe Deferral Mechanism
CC: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <1317963790-29426-1-git-send-email-manjugk@ti.com>
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Original patch posted at:
http://comments.gmane.org/gmane.linux.kernel/1194346

Enhancements done to above patch:
 - checkpatch warning fixes
 - added Kconfig symbol CONFIG_PROBE_DEFER
 - replacing normal workqueue with singlethread_workqueue
 - handling -EPROBE_DEFER error

Apart from that, OMAP HSMMC and GPIO drivers are adopted to use
deferral probe mechanism and successfully tested on omap3 beagle
board.

Applies cleanly on top of v3.1-rc8

G, Manjunath Kondaiah (3):
  drivercore: add new error value for deferred probe
  gpiolib: handle deferral probe error
  omap: hsmmc: use platform_driver_register

Grant Likely (1):
  drivercore: Add driver probe deferral mechanism

Mark Brown (1):
  regulator: Support driver probe deferral

 drivers/base/Kconfig          |   11 +++
 drivers/base/base.h           |    3 +
 drivers/base/core.c           |    6 ++
 drivers/base/dd.c             |  145 +++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        |    6 +-
 drivers/mmc/host/omap_hsmmc.c |    7 +-
 drivers/regulator/core.c      |    4 +-
 include/linux/device.h        |    7 ++
 include/linux/errno.h         |    1 +
 9 files changed, 183 insertions(+), 7 deletions(-)

-- 
Cc: linux-omap@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dilan Lee <dilee@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>

1.7.4.1

