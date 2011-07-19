Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1GSIOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:14:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43009 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1GSIOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:14:24 -0400
Subject: [PATCH] HID: emsff: properly handle emsff_init failure
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ignaz Forster <ignaz.forster@gmx.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 16:14:04 +0800
Message-ID: <1311063244.7304.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

emsff_init() may fail, let's properly handle the failure.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hid/hid-emsff.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
index 81877c6..a5dc13f 100644
--- a/drivers/hid/hid-emsff.c
+++ b/drivers/hid/hid-emsff.c
@@ -126,7 +126,12 @@ static int ems_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err;
 	}
 
-	emsff_init(hdev);
+	ret = emsff_init(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "force feedback init failed\n");
+		hid_hw_stop(hdev);
+		goto err;
+	}
 
 	return 0;
 err:
-- 
1.7.4.1



