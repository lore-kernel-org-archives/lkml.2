Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1ATScX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:32:23 -0500
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:48624 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753582Ab1ATScV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:32:21 -0500
Subject: [PATCH 3/3] hid: return -ENOMEM when memory allocation fails
From: Davidlohr Bueso <dave@gnu.org>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 15:32:10 -0300
Message-ID: <1295548330.2089.13.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/hid/hid-core.c      |    2 +-
 drivers/hid/usbhid/hiddev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d678cf3..eb2251c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -129,7 +129,7 @@ static int open_collection(struct hid_parser *parser, unsigned type)
 				parser->device->collection_size * 2, GFP_KERNEL);
 		if (collection == NULL) {
 			dbg_hid("failed to reallocate collection array\n");
-			return -1;
+			return -ENOMEM;
 		}
 		memcpy(collection, parser->device->collection,
 			sizeof(struct hid_collection) *
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index af0a7c1..38513cc 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -894,7 +894,7 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
 	}
 
 	if (!(hiddev = kzalloc(sizeof(struct hiddev), GFP_KERNEL)))
-		return -1;
+		return -ENOMEM;
 
 	init_waitqueue_head(&hiddev->wait);
 	INIT_LIST_HEAD(&hiddev->list);
-- 
1.7.1




