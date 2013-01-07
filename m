Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3AGHSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:18:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:19149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3AGHSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:18:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="240732759"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv2 0/9] Thermal Framework Enhancements
Date: Mon,  7 Jan 2013 12:43:17 +0530
Message-Id: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a v2 of the previous versions submitted here:
[v1]:  https://lkml.org/lkml/2012/12/18/108 
[RFC]: https://patchwork.kernel.org/patch/1758921/

This patch set is based on Rui's -thermal tree, and is
tested on a Core-i5 and an Atom netbook.

Changes Since v1:
 * Removed kobject creation for thermal_trip and thermal_map
   nodes as per Greg-KH's comments.
 * Added ABI Documentation under 'testing'.
 * Modified the GET_INDEX macro to be more linux-like, thanks
   to Joe Perches.
 * Added get_[sensor/cdev]_by_name APIs to thermal.h

This series contains 9 patches:
Patch 1/9: Creates new sensor level APIs
Patch 2/9: Creates new zone level APIs. The existing tzd structure is
           kept as such for clarity and compatibility purposes.
Patch 3/9: Creates functions to add/remove a cdev to/from a zone. The
           existing tcd structure need not be modified.
Patch 4/9: Adds sensorX_trip_[active/passive/hot/critical] sysfs nodes,
	   under /sys/class/thermal/zoneY/. This exposes various trip
           points for sensorX present in zoneY.
Patch 5/9: Adds mapX sysfs node. It is a compact representation
           of the binding relationship between a sensor and a cdev,
           within a zone.
Patch 6/9: Creates Documentation for the new APIs. A new file is
           created for clarity. Final goal is to merge with the existing
           file or refactor the files, as whatever seems appropriate.
Patch 7/9: Make PER ZONE values configurable through Kconfig
Patch 8/9: Add ABI documentation for sysfs interfaces introduced in this patch.
Patch 9/9: A dummy driver that can be used for testing. This is not for merge.

Thanks to Greg-KH, Hongbo Zhang and Joe Perches for their comments on v1.

Durgadoss R (9):
  Thermal: Create sensor level APIs
  Thermal: Create zone level APIs
  Thermal: Add APIs to bind cdev to new zone structure
  Thermal: Add trip point sysfs nodes for sensor
  Thermal: Create 'mapX' sysfs node for a zone
  Thermal: Add Documentation to new APIs
  Thermal: Make PER_ZONE values configurable
  Thermal: Add ABI Documentation for sysfs interfaces
  Thermal: Dummy driver used for testing

 Documentation/ABI/testing/sysfs-class-thermal |   93 +++
 Documentation/thermal/sysfs-api2.txt          |  248 +++++++
 drivers/thermal/Kconfig                       |   19 +
 drivers/thermal/Makefile                      |    3 +
 drivers/thermal/thermal_sys.c                 |  881 +++++++++++++++++++++++++
 drivers/thermal/thermal_test.c                |  315 +++++++++
 include/linux/thermal.h                       |  117 +++-
 7 files changed, 1675 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-thermal
 create mode 100644 Documentation/thermal/sysfs-api2.txt
 create mode 100644 drivers/thermal/thermal_test.c

-- 
1.7.9.5

