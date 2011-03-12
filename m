Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1CLUXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:23:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35765 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1CLUXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:23:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AxWxQa2k4NsLrY9nal4X6cdeTCAkuSPNZkmxNCmACV1klAKAxaOy509Nyq8VDQGyYh
         a38vmQ6hsL7MmqW/+Gq783GoOipyIpBrPeQqQAqqtks0CQLOZgNC2Rbp4GkcvZk9id1V
         TFoSICwE3GCfkatUIopMHNY5VR59DSAblb/yU=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 00/13]  V3 Split i2c-designware.c to support PCI drivers.
Date: Sat, 12 Mar 2011 12:23:14 -0800
Message-Id: <1299961407-26852-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch set reworks i2c-designware.c to enable supporting multiple
instances of the driver in the system and adds support for Designware
I2C IP cores behind PCI devices.

The patch set has been refactored to hopefully make it easier to
review.

TODO:
Ben disliked the module names, they haven't changed yet waiting for
feedback on the list.

Changes since V2:

Fixed bug that kept PCI driver from compiling :-(

PCI Runtime power mangement code changed to remove warning at probe
time and remove device.

Fix checking of component version on big endian machine to work
correctly.
 
Changes since V1 of the patch set:

Patches 1-3 are now Jean-Hugues Deschenes patches unmodified from
http://www.spinics.net/lists/linux-i2c/msg02421.html

Patch 4 moves the version checking introduced in Jean's code to the
core init function.

Patch 5 splits i2c-designware.c into IP core and bus specific files.

Patch 6-9 rework i2c-designware-core.c and i2c-designware-platdrv.c to
add the ability to support multiple instances of the driver.

Patch 10 Finishes moving all register access and associated offset and
bit definitions into the core.

Patch 11 Adds support for designware I2C IP cores behind PCI
devices on the Moorestown and Medfield platforms. removed change to
authors name.

Patch 12 Adds runtime power management to the PCI driver.    


Dirk Brandewie (10):
  i2c-designware: Move checking of IP core version to i2c_dw_init()
  i2c-designware: split of i2c-designware.c into core and bus specific
    parts
  i2c-designware: Move retriveving the clock speed out of core code.
  i2c-designware: move i2c functionality bit field to be adapter
    specific
  i2c-designware: move controller config to bus specific portion of
    driver
  i2c-designware: Support multiple cores using same ISR
  i2c-designware: Push all register reads/writes into the core code.
  i2c-designware: Add support for Designware core behind PCI devices.
  i2c-designware: Add runtime power management support
  i2c-intel-mid.c: Remove i2c-intel-mid.c

Jean-Hugues Deschenes (3):
  i2c-designware: Use local version of readl & writel
  i2c-designware: Check component type register
  i2c-designware: Allow mixed endianness accesses

 drivers/i2c/busses/Kconfig                         |   25 +-
 drivers/i2c/busses/Makefile                        |    6 +-
 .../{i2c-designware.c => i2c-designware-core.c}    |  383 ++-----
 drivers/i2c/busses/i2c-designware-core.h           |  106 ++
 drivers/i2c/busses/i2c-designware-pcidrv.c         |  405 +++++++
 drivers/i2c/busses/i2c-designware-platdrv.c        |  215 ++++
 drivers/i2c/busses/i2c-intel-mid.c                 | 1135 --------------------
 7 files changed, 862 insertions(+), 1413 deletions(-)
 rename drivers/i2c/busses/{i2c-designware.c => i2c-designware-core.c} (65%)
 create mode 100644 drivers/i2c/busses/i2c-designware-core.h
 create mode 100644 drivers/i2c/busses/i2c-designware-pcidrv.c
 create mode 100644 drivers/i2c/busses/i2c-designware-platdrv.c
 delete mode 100644 drivers/i2c/busses/i2c-intel-mid.c

-- 
1.7.3.4

