Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab2LMOdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:33:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2LMOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Igor Murzov <e-mail@date.by>, Zhang Rui <rui.zhang@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 161/241] ACPI video: Ignore errors after _DOD evaluation.
Date: Thu, 13 Dec 2012 11:58:46 -0200
Message-Id: <1355407206-17100-162-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Murzov <e-mail@date.by>

commit fba4e087361605d1eed63343bb08811f097c83ee upstream.

There are systems where video module known to work fine regardless
of broken _DOD and ignoring returned value here doesn't cause
any issues later. This should fix brightness controls on some laptops.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47861

Signed-off-by: Igor Murzov <e-mail@date.by>
Reviewed-by: Sergey V <sftp.mtuci@gmail.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/acpi/video.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 1e0a9e1..9fe2659 100644
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
1.7.9.5

