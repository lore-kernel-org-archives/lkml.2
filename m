Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab0JHNmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:42:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:46844 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab0JHNmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:42:24 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCHv2 0/5] BH1770GLC, SFH7770 and APDS990x als / proximity sensor drivers
Date: Fri,  8 Oct 2010 16:41:59 +0300
Message-Id: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 08 Oct 2010 13:42:09.0609 (UTC) FILETIME=[9AD4FB90:01CB66EE]
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

Changes in patch set version 2:
- sysfs naming convention changed
- sysfs sensor_range entries added
- "xxx yyy" sysfs entries changes to two separate entries
- 10x sysfs entry replaced with %d.%d
- const added to tables
- meaning of rate entries changed to Hertz
- various mutex corrections and comments
- cleaned up bracket
- rate selection selects closest one instead strict match
- Documentation updated to match changes
- Some bug fixes which I noticed in tests
- Some code cleanup
- EAGAIN is not returned in sysfs read. Instead wait for result or
  timeout with -EIO (something is broken if timeout happens)

Tested on top of 2.6.36-rc5

Samu Onkalo (5):
  misc: Driver for bh1770glc / sfh7770 ALS and proximity sensor
  misc: update bhsfh driver to Kconfig and Makefile
  misc: Driver for APDS990X ALS and proximity sensors
  misc: update apds990x driver to Kconfig and Makefile
  Documentation: Short descriptions for bhsfh and apds990x drivers

 Documentation/misc-devices/apds990x.txt |  152 ++++
 Documentation/misc-devices/bhsfh.txt    |  148 ++++
 drivers/misc/Kconfig                    |   21 +
 drivers/misc/Makefile                   |    2 +
 drivers/misc/apds990x.c                 | 1303 ++++++++++++++++++++++++++++
 drivers/misc/bhsfh.c                    | 1443 +++++++++++++++++++++++++++++++
 include/linux/i2c/apds990x.h            |   58 ++
 include/linux/i2c/bhsfh.h               |   42 +
 8 files changed, 3169 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/apds990x.txt
 create mode 100644 Documentation/misc-devices/bhsfh.txt
 create mode 100644 drivers/misc/apds990x.c
 create mode 100644 drivers/misc/bhsfh.c
 create mode 100644 include/linux/i2c/apds990x.h
 create mode 100644 include/linux/i2c/bhsfh.h

