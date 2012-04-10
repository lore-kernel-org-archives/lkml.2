Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2DJWX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:23:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:33155 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab2DJWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:23:28 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/5] ACPI: Add _OST support for ACPI hotplug
Date: Tue, 10 Apr 2012 16:21:46 -0600
Message-Id: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches supports ACPI _OST (OSPM Status Indication)
method for ACPI-based CPU and memory hotplug operations.  After
ACPI-based hotplug operation completed, OSPM calls _OST to convey
the completion status to ACPI firmware.  If _OST is not present,
this change has no effect on the platform.

The _OST definition can be found in section 6.3.5 of ACPI 5.0 spec.
The HPPF spec below also describes hotplug flows with _OST.

  DIG64 Hot-Plug & Partitioning Flow (HPPF) Specification R1.0
  http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf

The change was tested by overriding DSDT with fake _OST methods.

---
Toshi Kani (4):
 ACPI: Set hotplug _OST support bit to _OSC
 ACPI: Add acpi_evaluate_ost() for calling _OST
 ACPI: Add _OST support for ACPI CPU hotplug
 ACPI: Add _OST support for ACPI memory hotplug

 drivers/acpi/acpi_memhotplug.c  |   43 +++++++++++++++++++++++++++++----------
 drivers/acpi/bus.c              |    5 ++++
 drivers/acpi/processor_driver.c |   28 ++++++++++++++++++-------
 drivers/acpi/utils.c            |   34 ++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h         |    3 ++
 include/linux/acpi.h            |   26 ++++++++++++++++++++++-
 6 files changed, 119 insertions(+), 20 deletions(-)

