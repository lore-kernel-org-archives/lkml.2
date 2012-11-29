Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2K2Ly6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:54:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab2K2LxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:53:21 -0500
From: Colin King <colin.king@canonical.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ACPI dock: remove unnecessary newline from exception message
Date: Thu, 29 Nov 2012 11:53:12 +0000
Message-Id: <1354189996-14431-2-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
References: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

ACPI_EXCEPTION() already appends a newline, so there is no
need for the failed _DCK messaged to include one too.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/acpi/dock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 88eb143..a873c6b 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -475,7 +475,7 @@ static void handle_dock(struct dock_station *ds, int dock)
 	status = acpi_evaluate_object(ds->handle, "_DCK", &arg_list, &buffer);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
 		ACPI_EXCEPTION((AE_INFO, status, "%s - failed to execute"
-			" _DCK\n", (char *)name_buffer.pointer));
+			" _DCK", (char *)name_buffer.pointer));
 
 	kfree(buffer.pointer);
 	kfree(name_buffer.pointer);
-- 
1.8.0

