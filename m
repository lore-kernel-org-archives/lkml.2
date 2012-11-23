Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2KWLdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:33:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:1596 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab2KWLdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:33:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,307,1352102400"; 
   d="scan'208";a="253225933"
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, mika.westerberg@linux.intel.com,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] PNPACPI: exclude devices already bound
Date: Fri, 23 Nov 2012 13:35:59 +0200
Message-Id: <1353670561-22515-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353670561-22515-1-git-send-email-adrian.hunter@intel.com>
References: <1353670561-22515-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

This will exclude ACPI platform devices from also being created
as PNP devices.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/pnp/pnpacpi/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 26b5d4b..653d563 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -242,6 +242,10 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	char *pnpid;
 	struct acpi_hardware_id *id;
 
+	/* Skip devices that are already bound */
+	if (device->physical_node_count)
+		return 0;
+
 	/*
 	 * If a PnPacpi device is not present , the device
 	 * driver should not be loaded.
-- 
1.7.11.7

