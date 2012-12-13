Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab2LMORf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:17:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440Ab2LMOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 234/241] ACPI: missing break
Date: Thu, 13 Dec 2012 11:59:59 -0200
Message-Id: <1355407206-17100-235-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 879dca019dc43a1622edca3e7dde644b14b5acc5 upstream.

We handle NOTIFY_THROTTLING so don't then fall through to unsupported event.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/acpi/processor_driver.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index bbac51e..4a2c131 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -407,6 +407,7 @@ static void acpi_processor_notify(struct acpi_device *device, u32 event)
 		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
+		break;
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Unsupported event [0x%x]\n", event));
-- 
1.7.9.5

