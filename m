Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2JFBzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 21:55:07 -0400
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:45984
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319Ab2JFBzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 21:55:04 -0400
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: andrey.smrinov@convergeddevices.net
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] A driver for Si476x series of chips
Date: Fri,  5 Oct 2012 18:54:56 -0700
Message-Id: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a second version of the patchset originaly posted here:
https://lkml.org/lkml/2012/9/13/590

To save everyone's time I'll repost the original description of it:


This patchset contains a driver for a Silicon Laboratories 476x series
of radio tuners. The driver itself is implemented as an MFD devices
comprised of three parts: 1. Core device that provides all the other
devices with basic functionality and locking scheme. 2. Radio device
that translates between V4L2 subsystem requests into Core device
commands. 3. Codec device that does similar to the earlier described
task, but for ALSA SoC subsystem.

This driver has been tested to work in two different sytems: 1. A
 custom Tegra-based ARM board(design is based on Harmony board)
 running linux kernel 3.1.10 kernel 2. A standalone USB-connected
 board that has a dedicated Cortex M3 working as a transparent USB to
 I2C bridge which was connected to a off-the-shelf x86-64 laptop
 running Ubuntu with 3.2.0 kernel.

As far as SubmitChecklist is concerned following criteria should be
satisfied: 2b, 3, 5, 7, 9, 10


Now it is made against git.linuxtv.org/media_tree.git repository
instead of linux-stable.

I tried to take into account all the flaws pointed by Mark and Hans,
but since the amount of changes I had to made was not trivial I
wouldn't be surprized if I missed something that was shown to me. I
would like to appologize in advance if this patchset contains some
unfixed problems pointed out in the previous version.

Andrey Smirnov (6):
  Add header files and Kbuild plumbing for SI476x MFD core
  Add the main bulk of core driver for SI476x code
  Add commands abstraction layer for SI476X MFD
  Add chip properties handling code for SI476X MFD
  Add a V4L2 driver for SI476X MFD
  Add a codec driver for SI476X MFD

 drivers/media/radio/Kconfig        |   17 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-si476x.c | 1159 ++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |   14 +
 drivers/mfd/Makefile               |    3 +
 drivers/mfd/si476x-cmd.c           | 1493 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/si476x-i2c.c           |  974 +++++++++++++++++++++++
 drivers/mfd/si476x-prop.c          |  477 ++++++++++++
 include/linux/mfd/si476x-core.h    |  529 +++++++++++++
 include/media/si476x.h             |  449 +++++++++++
 sound/soc/codecs/Kconfig           |    4 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/si476x.c                 |  255 ++++++
 13 files changed, 5377 insertions(+)
 create mode 100644 drivers/media/radio/radio-si476x.c
 create mode 100644 drivers/mfd/si476x-cmd.c
 create mode 100644 drivers/mfd/si476x-i2c.c
 create mode 100644 drivers/mfd/si476x-prop.c
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/media/si476x.h
 create mode 100644 sound/soc/si476x.c

-- 
1.7.9.5

