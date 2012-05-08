Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2EHUPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:15:16 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:3932 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab2EHUPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:15:15 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 0/7] ACPI: Add _OST support for ACPI hotplug
Date: Tue,  8 May 2012 14:12:17 -0600
Message-Id: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset supports ACPI OSPM Status Indication (_OST) method for
ACPI CPU/memory/container hotplug operations and sysfs eject. After
ACPI hotplug operation has completed, OSPM calls _OST to indicate the
status of the operation to the platform. If _OST is not present, this
patchset has no effect on the platform.

This _OST support can be enabled or disabled with a new config option
CONFIG_ACPI_HOTPLUG_OST. This option is disabled by default. When
this option is disabled, this patchset has no effect on the platform.

The _OST definition can be found in section 6.3.5 of ACPI 5.0 spec.
The HPPF spec below also describes hotplug flows with _OST.

  DIG64 Hot-Plug & Partitioning Flow (HPPF) Specification R1.0
  http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf

The changes have been tested with simulated _OST methods.

v2:
 - Added CONFIG_ACPI_HOTPLUG_OST option. 
 - Added _OST support for container hotplug and sysfs eject.
 - Reordered patchset to enable _OST support bit of _OSC in the 
   last patch.

---
Toshi Kani (7):
 ACPI: Add CONFIG_HOTPLUG_OST option
 ACPI: Add an interface to evaluate _OST
 ACPI: Add _OST support for sysfs eject
 ACPI: Add _OST support for ACPI CPU hotplug
 ACPI: Add _OST support for ACPI memory hotplug
 ACPI: Add _OST support for ACPI container hotplug
 ACPI: Set hotplug _OST support bit to _OSC

 drivers/acpi/Kconfig            |   14 +++++++++
 drivers/acpi/acpi_memhotplug.c  |   43 +++++++++++++++++++++-------
 drivers/acpi/bus.c              |    4 +++
 drivers/acpi/container.c        |   43 +++++++++++++++++++----------
 drivers/acpi/processor_driver.c |   28 +++++++++++++-----
 drivers/acpi/scan.c             |   58 +++++++++++++++++++++++++++++++++------
 drivers/acpi/utils.c            |   38 +++++++++++++++++++++++++
 include/acpi/acpi_bus.h         |   12 +++++++-
 include/linux/acpi.h            |   31 ++++++++++++++++++++-
 9 files changed, 226 insertions(+), 45 deletions(-)

