Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2GTQ7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:59:11 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1971 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2GTQ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:59:09 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v2 0/4] ACPI: hotplug messages improvement
Date: Fri, 20 Jul 2012 10:54:12 -0600
Message-Id: <1342803256-17514-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset improves logging messages for ACPI CPU, Memory, and
Container hotplug notify handlers.  The patchset introduces a set of
new macro interfaces, acpi_pr_<level>(), and updates the notify
handlers to use them.  acpi_pr_<level>() appends "ACPI" prefix and
ACPI object path to the messages.  This improves diagnostics in
hotplug operations since it identifies an object that caused an
issue in a log file.

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
 include/acpi/acpi_bus.h         |   20 ++++++++++++++++++++
 5 files changed, 90 insertions(+), 30 deletions(-)
