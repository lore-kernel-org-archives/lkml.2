Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2K2Lx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:53:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2K2LxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:53:21 -0500
From: Colin King <colin.king@canonical.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ACPI video: remove unnecessary newline from error messages
Date: Thu, 29 Nov 2012 11:53:13 +0000
Message-Id: <1354189996-14431-3-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
References: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

ACPI_ERROR() already appends a newline, so there is no
need for the error messages to include one too.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/acpi/video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 0230cb6..bac0768 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -659,7 +659,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 			br->levels[i] = br->levels[i - level_ac_battery];
 		count += level_ac_battery;
 	} else if (level_ac_battery > 2)
-		ACPI_ERROR((AE_INFO, "Too many duplicates in _BCL package\n"));
+		ACPI_ERROR((AE_INFO, "Too many duplicates in _BCL package"));
 
 	/* Check if the _BCL package is in a reversed order */
 	if (max_level == br->levels[2]) {
@@ -668,7 +668,7 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 			acpi_video_cmp_level, NULL);
 	} else if (max_level != br->levels[count - 1])
 		ACPI_ERROR((AE_INFO,
-			    "Found unordered _BCL package\n"));
+			    "Found unordered _BCL package"));
 
 	br->count = count;
 	device->brightness = br;
-- 
1.8.0

