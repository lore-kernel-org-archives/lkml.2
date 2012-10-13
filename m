Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2JMAtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 20:49:39 -0400
Received: from forward4h.mail.yandex.net ([84.201.186.22]:59753 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2JMAth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 20:49:37 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2012 20:49:37 EDT
From: Igor Murzov <e-mail@date.by>
To: linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Stefan Wilkens <stefanwilkens@gmail.com>,
        Sergey V <sftp.mtuci@gmail.com>, linux-kernel@vger.kernel.org,
        Igor Murzov <e-mail@date.by>
Subject: [PATCH] ACPI video: Ignore errors after _DOD evaluation.
Date: Sat, 13 Oct 2012 04:41:25 +0400
Message-Id: <1350088885-13918-1-git-send-email-e-mail@date.by>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are systems where video module known to work fine regardless
of broken _DOD and ignoring returned value here doesn't cause
any issues later. This should fix brightness controls on some laptops.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47861

Signed-off-by: Igor Murzov <e-mail@date.by>
Reviewed-by: Sergey V <sftp.mtuci@gmail.com>
---
Previous discussion of the issue:
http://thread.gmane.org/gmane.linux.acpi.devel/56345

 drivers/acpi/video.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index f94d4c8..0230cb6 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1345,12 +1345,15 @@ static int
 acpi_video_bus_get_devices(struct acpi_video_bus *video,
 			   struct acpi_device *device)
 {
-	int status;
+	int status = 0;
 	struct acpi_device *dev;
 
-	status = acpi_video_device_enumerate(video);
-	if (status)
-		return status;
+	/*
+	 * There are systems where video module known to work fine regardless
+	 * of broken _DOD and ignoring returned value here doesn't cause
+	 * any issues later.
+	 */
+	acpi_video_device_enumerate(video);
 
 	list_for_each_entry(dev, &device->children, node) {
 
-- 
1.7.12.1

