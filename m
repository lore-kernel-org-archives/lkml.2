Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0IMTsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1867 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab0IMTsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:24 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 03/25] drivers/acpi: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:41 -0700
Message-Id: <586912c51cea49db9bb042a9badae0bbe8cba529.1284406638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/acpi/sleep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index cf82989..566b1cdd 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -567,7 +567,7 @@ int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
 	struct acpi_device *adev;
-	char acpi_method[] = "_SxD";
+	char acpi_method[sizeof("_SxD")];
 	unsigned long long d_min, d_max;
 
 	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
@@ -575,7 +575,7 @@ int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p)
 		return -ENODEV;
 	}
 
-	acpi_method[2] = '0' + acpi_target_sleep_state;
+	sprintf(acpi_method, "_S%cD", '0' + acpi_target_sleep_state);
 	/*
 	 * If the sleep state is S0, we will return D3, but if the device has
 	 * _S0W, we will use the value from _S0W
-- 
1.7.3.rc1

