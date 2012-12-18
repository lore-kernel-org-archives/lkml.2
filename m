Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2LRJd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:33:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:29474 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab2LRJd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:33:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,308,1355126400"; 
   d="scan'208";a="233077750"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 0/8] Thermal Framework Enhancements
Date: Tue, 18 Dec 2012 14:59:29 +0530
Message-Id: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a v1 based on the RFC submitted here:
https://patchwork.kernel.org/patch/1758921/

This patch set is based on Rui's -thermal tree, and is
tested on a Core-i5 and an Atom netbook.

This series contains 8 patches:
Patch 1/8: Creates new sensor level APIs
Patch 2/8: Creates new zone level APIs. The existing tzd structure is
           kept as such for clarity and compatibility purposes.
Patch 3/8: Creates functions to add/remove a cdev to/from a zone. The
           existing tcd structure need not be modified.
Patch 4/8: Adds a thermal_trip sysfs node, which exposes various trip
           points for all sensors present in a zone.
Patch 5/8: Adds a thermal_map sysfs node. It is a compact representation
           of the binding relationship between a sensor and a cdev,
           within a zone.
Patch 6/8: Creates Documentation for the new APIs. A new file is
           created for clarity. Final goal is to merge with the existing
           file or refactor the files, as whatever seems appropriate.
Patch 7/8: Make PER ZONE values configurable through Kconfig
Patch 8/8: A dummy driver that can be used for testing. This is not for merge.

Thanks to Rui Zhang, Honghbo Zhang, Wei Ni for their feedback on the
RFC version.

Durgadoss R (8):
  Thermal: Create sensor level APIs
  Thermal: Create zone level APIs
  Thermal: Add APIs to bind cdev to new zone structure
  Thermal: Add Thermal_trip sysfs node
  Thermal: Add 'thermal_map' sysfs node
  Thermal: Add Documentation to new APIs
  Thermal: Make PER_ZONE values configurable
  Thermal: Dummy driver used for testing

 Documentation/thermal/sysfs-api2.txt |  248 +++++++++
 drivers/thermal/Kconfig              |   19 +
 drivers/thermal/Makefile             |    3 +
 drivers/thermal/thermal_sys.c        |  932 ++++++++++++++++++++++++++++++++++
 drivers/thermal/thermal_test.c       |  315 ++++++++++++
 include/linux/thermal.h              |  124 +++++
 6 files changed, 1641 insertions(+)
 create mode 100644 Documentation/thermal/sysfs-api2.txt
 create mode 100644 drivers/thermal/thermal_test.c

-- 
1.7.9.5

