Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0JKLHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 07:07:01 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:65523 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab0JKLG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 07:06:58 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCHv3 0/5] [PATCHv3 0/6] BH1770GLC, SFH7770 and APDS990x als / proximity sensor drivers
Date: Mon, 11 Oct 2010 14:06:44 +0300
Message-Id: <1286795209-12487-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch set contains two drivers. One for BH1770GLC / SFH7770 chips and
one for APDS990X chip.

Both drivers have similar sysfs based interface. Both supports
pm_runtime and regulator frame work. There is short documentation
for both drivers.

Unfortunately I can't promise data sheets to public access.

changes since patch set version 3:

- unused variables removed
- several if statements cleaned up (brackets, else if statements)
- bug fix: chip was accessed after powering regulators off
- bug fix: unbalance at runtime-pm enable - disable corrected at module probe
- PAGE_SIZEs removed
- Some duplicate code removed to one function
- documentation updated and typing errors corrected
- platform data documentation moved to header file as kernel-doc format
- bhsfh -> bh1770glc

Tested on top of 2.6.36-rc5

Samu Onkalo (5):
  misc: Driver for bh1770glc / sfh7770 ALS and proximity sensor
  misc: update bh1770glc driver to Kconfig and Makefile
  misc: Driver for APDS990X ALS and proximity sensors
  misc: update apds990x driver to Kconfig and Makefile
  Documentation: Short descriptions for bh1770glc and apds990x drivers

 Documentation/misc-devices/apds990x.txt  |  113 +++
 Documentation/misc-devices/bh1770glc.txt |  118 +++
 drivers/misc/Kconfig                     |   21 +
 drivers/misc/Makefile                    |    2 +
 drivers/misc/apds990x.c                  | 1295 +++++++++++++++++++++++++++
 drivers/misc/bh1770glc.c                 | 1413 ++++++++++++++++++++++++++++++
 include/linux/i2c/apds990x.h             |   79 ++
 include/linux/i2c/bh1770glc.h            |   53 ++
 8 files changed, 3094 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/apds990x.txt
 create mode 100644 Documentation/misc-devices/bh1770glc.txt
 create mode 100644 drivers/misc/apds990x.c
 create mode 100644 drivers/misc/bh1770glc.c
 create mode 100644 include/linux/i2c/apds990x.h
 create mode 100644 include/linux/i2c/bh1770glc.h

