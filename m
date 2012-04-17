Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2DQFsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:48:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:49201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2DQFsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89863269"
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.og>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 4/6] ACPI: Fix power resource's device power state when it's off
Date: Tue, 17 Apr 2012 13:47:54 +0800
Message-Id: <1334641676-14566-5-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power resource's device power state should be
ACPI_STATE_D3_COLD when it's off.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/power.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 27a2bad..d6065110 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -300,7 +300,7 @@ static int acpi_power_off(acpi_handle handle)
 		result = -ENODEV;
 	} else {
 		/* Update the power resource's _device_ power state */
-		resource->device->power.state = ACPI_STATE_D3;
+		resource->device->power.state = ACPI_STATE_D3_COLD;
 
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Power resource [%s] turned off\n",
@@ -735,7 +735,7 @@ static int acpi_power_add(struct acpi_device *device)
 		device->power.state = ACPI_STATE_D0;
 		break;
 	case ACPI_POWER_RESOURCE_STATE_OFF:
-		device->power.state = ACPI_STATE_D3;
+		device->power.state = ACPI_STATE_D3_COLD;
 		break;
 	default:
 		device->power.state = ACPI_STATE_UNKNOWN;
-- 
1.7.2.5

