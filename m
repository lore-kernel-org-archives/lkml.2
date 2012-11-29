Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2K2Lx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:53:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35019 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2K2LxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:53:21 -0500
From: Colin King <colin.king@canonical.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ACPI sysfs: remove unnecessary newline from exception
Date: Thu, 29 Nov 2012 11:53:14 +0000
Message-Id: <1354189996-14431-4-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
References: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

ACPI_EXCEPTION() already appends a newline, so there is no
need for the invalid GPE message to include one too.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/acpi/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 7c3f98b..9fc5379 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -498,7 +498,7 @@ static int get_status(u32 index, acpi_event_status *status,
 		result = acpi_get_gpe_device(index, handle);
 		if (result) {
 			ACPI_EXCEPTION((AE_INFO, AE_NOT_FOUND,
-					"Invalid GPE 0x%x\n", index));
+					"Invalid GPE 0x%x", index));
 			goto end;
 		}
 		result = acpi_get_gpe_status(*handle, index, status);
-- 
1.8.0

