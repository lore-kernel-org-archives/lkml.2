Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab2EKQlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:41:47 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:26347 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab2EKQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:40:46 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, shuahkhan@gmail.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 7/7] ACPI: Set hotplug _OST support bit to _OSC
Date: Fri, 11 May 2012 10:37:03 -0600
Message-Id: <1336754223-5346-8-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
References: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_ACPI_HOTPLUG_OST is enabled, set hotplug _OST support bit
OSC_SB_HOTPLUG_OST_SUPPORT to indicate that the OS supports hotplug
_OST by calling the platform-wide ACPI Operating System Capabilities
(_OSC).

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/bus.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 3263b68..93bf515 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -544,6 +544,10 @@ static void acpi_bus_osc_support(void)
 	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
 #endif
 
+#ifdef CONFIG_ACPI_HOTPLUG_OST
+	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_HOTPLUG_OST_SUPPORT;
+#endif
+
 	if (!ghes_disable)
 		capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_APEI_SUPPORT;
 	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
-- 
1.7.7.6

