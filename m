Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2G0DKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:10:42 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:16840 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2G0DKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:10:41 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v4 0/4] ACPI: hotplug messages improvement
Date: Thu, 26 Jul 2012 21:05:40 -0600
Message-Id: <1343358344-31517-1-git-send-email-toshi.kani@hp.com>
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

v4:
 - Changed to use dev_<level>() where it is appropriate.

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
 drivers/acpi/acpi_memhotplug.c  |   25 +++++++++++++------------
 drivers/acpi/container.c        |   10 ++--------
 drivers/acpi/processor_driver.c |   37 ++++++++++++++++++++++---------------
 drivers/acpi/utils.c            |   34 ++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h         |   31 +++++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+), 35 deletions(-)
