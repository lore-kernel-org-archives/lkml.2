Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1BOWZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:25:36 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48920 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1BOWZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:25:34 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] mfd-core: clean up platform_data/driver_data from mfd_cell
Date: Tue, 15 Feb 2011 14:25:20 -0800
Message-Id: <1297808729-21110-1-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches build on top of the prior MFD set (that adds mfd_get_cell
and friends to the core API).

This set gets rid of driver_data, which a number of people have issues with
(and some drivers were using in a buggy fashion), as well as renaming
platform_data to mfd_data.

 b/drivers/gpio/rdc321x-gpio.c       |    2 -
 b/drivers/mfd/ab3100-core.c         |    2 -
 b/drivers/mfd/ab3550-core.c         |    2 -
 b/drivers/mfd/asic3.c               |    2 -
 b/drivers/mfd/davinci_voicecodec.c  |    4 +-
 b/drivers/mfd/htc-pasic3.c          |    3 --
 b/drivers/mfd/janz-cmodio.c         |    2 -
 b/drivers/mfd/mc13xxx-core.c        |    2 -
 b/drivers/mfd/mfd-core.c            |    1 
 b/drivers/mfd/rdc321x-southbridge.c |    4 +-
 b/drivers/mfd/sh_mobile_sdhi.c      |    2 -
 b/drivers/mfd/t7l66xb.c             |    2 -
 b/drivers/mfd/tc6387xb.c            |    2 -
 b/drivers/mfd/tc6393xb.c            |    2 -
 b/drivers/mfd/timberdale.c          |   54 ++++++++++++++++++------------------
 b/drivers/mfd/twl4030-codec.c       |    4 +-
 b/drivers/mfd/wl1273-core.c         |    4 +-
 b/drivers/mfd/wm8400-core.c         |    2 -
 b/drivers/mmc/host/tmio_mmc.c       |   26 ++++++-----------
 b/drivers/mtd/nand/tmio_nand.c      |    3 --
 b/drivers/video/tmiofb.c            |   15 ++++------
 b/drivers/w1/masters/ds1wm.c        |    4 +-
 b/drivers/watchdog/rdc321x_wdt.c    |    2 -
 b/include/linux/mfd/core.h          |    8 ++---
 b/sound/soc/codecs/cq93vc.c         |    3 +-
 b/sound/soc/codecs/wm8400.c         |    2 -
 b/sound/soc/davinci/davinci-vcif.c  |    2 -
 drivers/mfd/asic3.c                 |    2 -
 drivers/mfd/t7l66xb.c               |    2 -
 drivers/mfd/tc6393xb.c              |    4 +-
 include/linux/mfd/core.h            |    3 --
 31 files changed, 79 insertions(+), 93 deletions(-)

