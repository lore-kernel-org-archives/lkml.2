Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1FITWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:22:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64443 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1FITWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wUk5EmMrcE8sq1eYQ8bNsIEBrsdFK6lKLwpByuatXNByjY7mmIsiRcJvGaWLzEmEDV
         JBT+6V0OU4kiGgHiXITYebbueLFmn9c3oelT+QtqfTVKWY6rOycEV6Fz/lD5TNpaOtG9
         hnAKkN+LeP26SI5MjeC/qFCUvDbcT1jdr8O8w=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 00/13]  V4 Split i2c-designware.c to support PCI drivers.
Date: Thu,  9 Jun 2011 12:21:37 -0700
Message-Id: <1307647310-24332-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch set reworks i2c-designware.c to enable supporting multiple
instances of the driver in the system and adds support for Designware
I2C IP cores behind PCI devices.

Previous discussion thread:
   https://lkml.org/lkml/2011/3/12/70

Changes since V3:
   commits 330d1c^..5c7d3e from linux-next rebased onto v3.0-rc2

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

 drivers/i2c/busses/Kconfig                  |   26 +-
 drivers/i2c/busses/Makefile                 |    6 +-
 drivers/i2c/busses/i2c-designware-core.c    |  705 +++++++++++++++++
 drivers/i2c/busses/i2c-designware-core.h    |  106 +++
 drivers/i2c/busses/i2c-designware-pcidrv.c  |  405 ++++++++++
 drivers/i2c/busses/i2c-designware-platdrv.c |  215 +++++
 drivers/i2c/busses/i2c-designware.c         |  847 --------------------
 drivers/i2c/busses/i2c-intel-mid.c          | 1140 ---------------------------
 8 files changed, 1448 insertions(+), 2002 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-designware-core.c
 create mode 100644 drivers/i2c/busses/i2c-designware-core.h
 create mode 100644 drivers/i2c/busses/i2c-designware-pcidrv.c
 create mode 100644 drivers/i2c/busses/i2c-designware-platdrv.c
 delete mode 100644 drivers/i2c/busses/i2c-designware.c
 delete mode 100644 drivers/i2c/busses/i2c-intel-mid.c

-- 
1.7.3.4

