Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2CWItI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:49:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57865 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2CWItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:49:02 -0400
From: Colin King <colin.king@canonical.com>
To: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI, APEI, fix ERST table size checking
Date: Fri, 23 Mar 2012 08:48:47 +0000
Message-Id: <1332492527-30702-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Check ERST size against acpi_table_erst rather than
acpi_table_einj.  The original code just so happened to work
because the ERST and EINJ headers are the same size.

I'm re-sending this patch as it didn't seem to get picked up when I first
sent it to the list back in September 2011.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable@kernel.org
---
 drivers/acpi/apei/erst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index eb9fab5..e4d9d24 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -917,7 +917,7 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
 {
 	if ((erst_tab->header_length !=
 	     (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
-	    && (erst_tab->header_length != sizeof(struct acpi_table_einj)))
+	    && (erst_tab->header_length != sizeof(struct acpi_table_erst)))
 		return -EINVAL;
 	if (erst_tab->header.length < sizeof(struct acpi_table_erst))
 		return -EINVAL;
-- 
1.7.0.4

