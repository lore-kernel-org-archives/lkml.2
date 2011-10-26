Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1JYXzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 19:55:23 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35219
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753339Ab1JYXzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 19:55:22 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        dmitry.torokhov@gmail.com, joe@perches.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/6] Staging: hv: mousevsc: Make  boolean states  boolean
Date: Tue, 25 Oct 2011 17:19:47 -0700
Message-Id: <1319588392-9982-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319588311-9935-1-git-send-email-kys@microsoft.com>
References: <1319588311-9935-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make some state that is boolean in nature, a boolean variable.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index ccd39c7..15aa2ce 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -148,7 +148,7 @@ struct  mousevsc_prt_msg {
  */
 struct mousevsc_dev {
 	struct hv_device	*device;
-	unsigned char		init_complete;
+	bool			init_complete;
 	struct mousevsc_prt_msg	protocol_req;
 	struct mousevsc_prt_msg	protocol_resp;
 	/* Synchronize the request/response if needed */
@@ -159,7 +159,7 @@ struct mousevsc_dev {
 	unsigned char		*report_desc;
 	u32			report_desc_size;
 	struct hv_input_dev_info hid_dev_info;
-	int			connected;
+	bool			connected;
 	struct hid_device       *hid_device;
 };
 
@@ -487,7 +487,7 @@ static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 	if (!hidinput_connect(hid_dev, 0)) {
 		hid_dev->claimed |= HID_CLAIMED_INPUT;
 
-		input_device->connected = 1;
+		input_device->connected = true;
 
 	}
 
@@ -558,7 +558,7 @@ static int mousevsc_remove(struct hv_device *dev)
 
 	if (input_dev->connected) {
 		hidinput_disconnect(input_dev->hid_device);
-		input_dev->connected = 0;
+		input_dev->connected = false;
 		hid_destroy_device(input_dev->hid_device);
 	}
 
-- 
1.7.4.1

