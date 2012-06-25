Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2FYRDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:03:54 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:31068 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2FYRDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:03:52 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        andi@firstfloor.org, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v5 0/6] ACPI: Add _OST support for ACPI hotplug
Date: Mon, 25 Jun 2012 10:59:27 -0600
Message-Id: <1340643573-28299-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * This version updates the change log in patch 5/6 per the email
   discussion below. 
     http://marc.info/?l=linux-acpi&m=133939897728489&w=2
   This patchset has been accepted in -next, and there is no code
   change in this version.

This patchset supports ACPI OSPM Status Indication (_OST) method for
ACPI CPU/memory/container hotplug operations and sysfs eject. After
an ACPI hotplug operation has completed, OSPM calls _OST to indicate
the result of the operation to the platform. If a platform does not
support _OST, this patchset has no effect on the platform.

This _OST support is enabled when all relevant ACPI hotplug operations,
such as CPU, memory and container hotplug, are enabled. This assures
consistent behavior among the hotplug operations with regarding the
_OST support.

Some platforms may require the OS to support _OST in order to support
ACPI hotplug operations. For example, if a platform has the management
console where user can request a hotplug operation from, this _OST
support would be required for the management console to show the result
of the hotplug request to user.

The _OST definition can be found in section 6.3.5 of ACPI 5.0 spec.
The HPPF spec below also describes hotplug flows with _OST.

  DIG64 Hot-Plug & Partitioning Flow (HPPF) Specification R1.0
  http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf

The changes have been tested with simulated _OST methods.

v5:
 - Updated change log in patch 5/6.

v4:
 - Removed CONFIG_ACPI_HOTPLUG_OST option.

v3:
 - Added more descriptions to the change logs.

v2:
 - Added CONFIG_ACPI_HOTPLUG_OST option. 
 - Added _OST support for container hotplug and sysfs eject.
 - Reordered patchset to enable _OST support bit of _OSC in the 
   last patch.

---
Toshi Kani (6):
 ACPI: Add an interface to evaluate _OST
 ACPI: Add _OST support for sysfs eject
 ACPI: Add _OST support for ACPI CPU hotplug
 ACPI: Add _OST support for ACPI memory hotplug
 ACPI: Add _OST support for ACPI container hotplug
 ACPI: Set hotplug _OST support bit to _OSC

 drivers/acpi/acpi_memhotplug.c  |   43 +++++++++++++++++++++-------
 drivers/acpi/bus.c              |    4 +++
 drivers/acpi/container.c        |   43 +++++++++++++++++++----------
 drivers/acpi/processor_driver.c |   28 +++++++++++++-----
 drivers/acpi/scan.c             |   58 +++++++++++++++++++++++++++++++++------
 drivers/acpi/utils.c            |   42 ++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h         |   12 +++++++-
 include/linux/acpi.h            |   40 ++++++++++++++++++++++++++-
 8 files changed, 225 insertions(+), 45 deletions(-)

