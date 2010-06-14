Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0FNH1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:27:18 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:40233 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0FNH1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:27:17 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2010 03:27:16 EDT
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: video: DMI workaround broken Acer 5710 BIOS enabling display brightness
Date: Mon, 14 Jun 2010 10:17:44 +0300
Message-Id: <1276499864-7609-1-git-send-email-ozan@pardus.org.tr>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acer Aspire 5710 suffers from a similar ACPI problem reported at:
 http://bugzilla.kernel.org/show_bug.cgi?id=13121

like the 5710Z and 7720.

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 drivers/acpi/video.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 9865d46..e2436d1 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -571,6 +571,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 	},
 	{
 	 .callback = video_set_bqc_offset,
+	 .ident = "Acer Aspire 5710",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5710"),
+		},
+	},
+	{
+	 .callback = video_set_bqc_offset,
 	 .ident = "Acer Aspire 5710Z",
 	 .matches = {
 		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
-- 
1.7.0.4

