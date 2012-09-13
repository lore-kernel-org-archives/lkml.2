Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2IMWvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:51:09 -0400
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:45784
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753535Ab2IMWvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:51:07 -0400
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] A driver for Si476x series of chips
Date: Thu, 13 Sep 2012 15:40:10 -0700
Message-Id: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains a driver for a Silicon Laboratories 476x series
of radio tuners. The driver itself is implemented as an MFD devices
comprised of three parts:
 1. Core device that provides all the other devices with basic
 functionality and locking scheme.
 2. Radio device that translates between V4L2 subsystem requests into
 Core device commands.
 3. Codec device that does similar to the earlier described task, but
 for ALSA SoC subsystem.

This driver has been tested to work in two different sytems:
 1. A custom Tegra-based ARM board(design is based on Harmony board)
 running linux kernel 3.1.10 kernel
 2. A standalone USB-connected board that has a dedicated Cortex M3
 working as a transparent USB to I2C bridge which was connected to a
 off-the-shelf x86-64 laptop running Ubuntu with 3.2.0 kernel.

As far as SubmitChecklist is concerned following criteria should be
satisfied: 2b, 3, 5, 7, 9, 10

Andrey Smirnov (3):
  Add a core driver for SI476x MFD
  Add a V4L2 driver for SI476X MFD
  Add a codec driver for SI476X MFD

 drivers/media/radio/Kconfig        |   17 +
 drivers/media/radio/radio-si476x.c | 1307 +++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |   14 +
 drivers/mfd/Makefile               |    3 +
 drivers/mfd/si476x-cmd.c           | 1509 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/si476x-i2c.c           | 1033 ++++++++++++++++++++++++
 drivers/mfd/si476x-prop.c          |  477 ++++++++++++
 include/linux/mfd/si476x-core.h    |  532 +++++++++++++
 include/media/si476x.h             |  461 +++++++++++
 sound/soc/codecs/Kconfig           |    4 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/si476x.c          |  346 +++++++++
 12 files changed, 5705 insertions(+)
 create mode 100644 drivers/media/radio/radio-si476x.c
 create mode 100644 drivers/mfd/si476x-cmd.c
 create mode 100644 drivers/mfd/si476x-i2c.c
 create mode 100644 drivers/mfd/si476x-prop.c
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/media/si476x.h
 create mode 100644 sound/soc/codecs/si476x.c

-- 
1.7.9.5

