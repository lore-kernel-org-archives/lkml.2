Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab1JZAXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:23:36 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33909
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754123Ab1JZAXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:23:30 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        dmitry.torokhov@gmail.com, joe@perches.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 2/6] Staging: hv: mousevsc: Inline the code for mousevsc_on_device_add()
Date: Tue, 25 Oct 2011 17:19:48 -0700
Message-Id: <1319588392-9982-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319588392-9982-1-git-send-email-kys@microsoft.com>
References: <1319588311-9935-1-git-send-email-kys@microsoft.com>
 <1319588392-9982-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline the code for mousevsc_on_device_add() as this only used from
the function mousevsc_probe().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 15aa2ce..0a5676c 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -494,7 +494,8 @@ static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 	input_device->hid_device = hid_dev;
 }
 
-static int mousevsc_on_device_add(struct hv_device *device)
+static int mousevsc_probe(struct hv_device *device,
+			const struct hv_vmbus_device_id *dev_id)
 {
 	int ret = 0;
 	struct mousevsc_dev *input_dev;
@@ -542,13 +543,6 @@ static int mousevsc_on_device_add(struct hv_device *device)
 	return ret;
 }
 
-static int mousevsc_probe(struct hv_device *dev,
-			const struct hv_vmbus_device_id *dev_id)
-{
-
-	return mousevsc_on_device_add(dev);
-
-}
 
 static int mousevsc_remove(struct hv_device *dev)
 {
-- 
1.7.4.1

