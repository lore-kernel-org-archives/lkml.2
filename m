Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2JIW2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:28:14 -0400
Received: from forward9.mail.yandex.net ([77.88.61.48]:33721 "EHLO
	forward9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2JIW2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:28:12 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2012 18:28:12 EDT
From: Igor Murzov <e-mail@date.by>
To: linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Sergey V <sftp.mtuci@gmail.com>, linux-kernel@vger.kernel.org,
        Igor Murzov <e-mail@date.by>
Subject: [PATCH] ACPI video: Ignore AE_AML_PACKAGE_LIMIT errors after _DOD evaluation.
Date: Wed, 10 Oct 2012 02:19:06 +0400
Message-Id: <1349821146-19155-1-git-send-email-e-mail@date.by>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix brightness controls on some laptops.
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47861

Signed-off-by: Igor Murzov <e-mail@date.by>
---
 drivers/acpi/video.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 1e0a9e1..01bb58d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1349,8 +1349,12 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
 	struct acpi_device *dev;
 
 	status = acpi_video_device_enumerate(video);
-	if (status)
-		return status;
+	if (status) {
+		if (status == AE_AML_PACKAGE_LIMIT)
+			status = 0; /* Ignore this error */
+		else
+			return status;
+	}
 
 	list_for_each_entry(dev, &device->children, node) {
 
-- 
1.7.12

