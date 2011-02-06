Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1BFM32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:29:28 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:43552 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1BFM3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:29:25 -0500
X-Originating-IP: 217.70.178.34
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/18] eeepc-wmi: return proper error code in eeepc_rfkill_set()
Date: Sun,  6 Feb 2011 13:28:30 +0100
Message-Id: <1296995324-5462-6-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
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
1.7.4.rc3

