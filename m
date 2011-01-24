Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1AXQha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:37:30 -0500
Received: from fb1.tech.numericable.fr ([82.216.111.51]:37783 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1AXQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:36:36 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 05/14] eeepc-wmi: return proper error code in eeepc_rfkill_set()
Date: Mon, 24 Jan 2011 17:23:49 +0100
Message-Id: <1295886238-15961-6-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
References: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index eb4c0ce..d823458 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -588,8 +588,14 @@ static int eeepc_rfkill_set(void *data, bool blocked)
 {
 	int dev_id = (unsigned long)data;
 	u32 ctrl_param = !blocked;
+	acpi_status status;
+
+	status = eeepc_wmi_set_devstate(dev_id, ctrl_param, NULL);
+
+	if (ACPI_FAILURE(status))
+		return -EIO;
 
-	return eeepc_wmi_set_devstate(dev_id, ctrl_param, NULL);
+	return 0;
 }
 
 static void eeepc_rfkill_query(struct rfkill *rfkill, void *data)
-- 
1.7.3.4

