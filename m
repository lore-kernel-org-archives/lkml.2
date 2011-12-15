Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1LOH2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:28:04 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:42197 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab1LOH2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:28:02 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] asus-laptop: log unknown keys
Date: Thu, 15 Dec 2011 08:27:31 +0100
Message-Id: <1323934059-1221-2-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
References: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index edaccad..b011be8 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1364,8 +1364,10 @@ err_btrfk:
  */
 static void asus_input_notify(struct asus_laptop *asus, int event)
 {
-	if (asus->inputdev)
-		sparse_keymap_report_event(asus->inputdev, event, 1, true);
+	if (!asus->inputdev)
+		return ;
+	if (!sparse_keymap_report_event(asus->inputdev, event, 1, true))
+		pr_info("Unknown key %x pressed\n", event);
 }
 
 static int asus_input_init(struct asus_laptop *asus)
-- 
1.7.5.4

