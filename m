Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab2DQFsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:48:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:49201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2DQFsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:48:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89863244"
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.og>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 0/6]: ACPI D3 state cleanup
Date: Tue, 17 Apr 2012 13:47:50 +0800
Message-Id: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently there are 2 ACPI D3 states defined:
ACPI_STATE_D3 and ACPI_STATE_D3_COLD.

But the uses of these 2 states are not clear/correct in some code.
For example, some code refer ACPI_STATE_D3 as D3hot and others refer
it as D3cold.

This patch set try to clean it up.

[PATCH 1/6] ACPI: D3cold state is always valid
[PATCH 2/6] ACPI: Set D3cold state as default device sleep state
[PATCH 3/6] ACPI: Set D3cold state as default inferred state
[PATCH 4/6] ACPI: Fix power resource's device power state when it's off
[PATCH 5/6] PCI/ACPI: Map PCI D3cold state to ACPI D3cold state
[PATCH 6/6] ACPI: Rename ACPI_STATE_D3 to ACPI_STATE_D3_HOT

 drivers/acpi/fan.c         |    4 ++--
 drivers/acpi/power.c       |   10 +++++-----
 drivers/acpi/scan.c        |   13 +++----------
 drivers/acpi/sleep.c       |    2 +-
 drivers/ata/libata-acpi.c  |    4 ++--
 drivers/ide/ide-acpi.c     |    4 ++--
 drivers/pci/pci-acpi.c     |    6 +++---
 drivers/pnp/pnpacpi/core.c |    4 ++--
 include/acpi/acpi_bus.h    |    2 +-
 include/acpi/actypes.h     |    2 +-
 10 files changed, 22 insertions(+), 29 deletions(-)

Thanks,
Lin Ming
