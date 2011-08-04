Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1HDVrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:47:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65445 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab1HDVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:47:32 -0400
From: Bojan Prtvar <prtvar.b@gmail.com>
To: jkosina@suse.cz, julia@diku.dk
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Bojan Prtvar <prtvar.b@gmail.com>
Subject: [PATCH 1/2 v2] HID: kfree() NULL pointer cleanup
Date: Thu,  4 Aug 2011 23:46:48 +0200
Message-Id: <1312494408-15500-1-git-send-email-prtvar.b@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for NULL pointers before kfree() is redundant.
v2:
No need for freeing pm in case when it's not allocated.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
---
 drivers/hid/hid-prodikeys.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 158b389..f779009 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -816,7 +816,7 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (pm == NULL) {
 		hid_err(hdev, "can't alloc descriptor\n");
 		ret = -ENOMEM;
-		goto err_free;
+		goto err_free_pk;
 	}
 
 	pm->pk = pk;
@@ -849,10 +849,10 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 err_stop:
 	hid_hw_stop(hdev);
 err_free:
-	if (pm != NULL)
-		kfree(pm);
-
+	kfree(pm);
+err_free_pk:
 	kfree(pk);
+
 	return ret;
 }
 
-- 
1.7.1

