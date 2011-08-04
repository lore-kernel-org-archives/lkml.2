Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1HDUoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:44:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1HDUn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:43:59 -0400
From: Bojan Prtvar <prtvar.b@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Bojan Prtvar <prtvar.b@gmail.com>
Subject: [PATCH 2/2] HID: kfree() NULL pointer cleanup
Date: Thu,  4 Aug 2011 22:43:46 +0200
Message-Id: <1312490626-14838-1-git-send-email-prtvar.b@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for NULL pointers before kfree() is redundant.

Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
---
 drivers/hid/hid-zydacron.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index e903715..1ad85f2 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -201,9 +201,7 @@ static void zc_remove(struct hid_device *hdev)
 	struct zc_device *zc = hid_get_drvdata(hdev);
 
 	hid_hw_stop(hdev);
-
-	if (NULL != zc)
-		kfree(zc);
+	kfree(zc);
 }
 
 static const struct hid_device_id zc_devices[] = {
-- 
1.7.1

