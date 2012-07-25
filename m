Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2GYXSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:18:03 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1627 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2GYXSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:18:01 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 0/4] ACPI: hotplug messages improvement
Date: Wed, 25 Jul 2012 17:12:54 -0600
Message-Id: <1343257978-7085-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset improves logging messages for ACPI CPU, Memory, and
Container hotplug notify handlers.  The patchset introduces a set of
new macro interfaces, acpi_pr_<level>(), and updates the notify
handlers to use them.  acpi_pr_<level>() appends "ACPI" prefix and
ACPI object path to the messages, and its usage model is similar to
dev_<level>().  This improves diagnostics in hotplug operations
since it identifies an object that caused an issue in a log file.

v3:
 - Changed acpi_pr_debug() to NOP when !DEBUG and !DYNAMIC_DEBUG.
   DYNAMIC_DEBUG will be supported later.
 - Added const to a path variable in acpi_printk().
 - Added more descriptions to the change log of patch 1/4.

v2:
 - Set buffer.pointer to NULL in acpi_printk().
 - Added acpi_pr_debug().

---
This patchset applies on top of the patch below.

[PATCH] ACPI: Add ACPI CPU hot-remove support
http://marc.info/?l=linux-acpi&m=134098193327362&w=2

---
Toshi Kani (4):
 ACPI: Add acpi_pr_<level>() interfaces
 ACPI: Update CPU hotplug messages
 ACPI: Update Memory hotplug messages
 ACPI: Update Container hotplug messages

---
 drivers/acpi/acpi_memhotplug.c  |   24 ++++++++++++------------
 drivers/acpi/container.c        |    6 +++---
 drivers/acpi/processor_driver.c |   36 +++++++++++++++++++++---------------
 drivers/acpi/utils.c            |   34 ++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h         |   31 +++++++++++++++++++++++++++++++
 5 files changed, 101 insertions(+), 30 deletions(-)
