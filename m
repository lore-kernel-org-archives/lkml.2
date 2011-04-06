Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab1DFVsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:48:41 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37782
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932304Ab1DFVr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:47:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 21/22] Staging: hv: Move module parameter to earlier in the file
Date: Wed,  6 Apr 2011 14:35:19 -0700
Message-Id: <1302125720-10808-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move module parameter to be earlier in the file.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 865b4dc..6ad1cad 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -126,6 +126,9 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request);
 
 static int blkvsc_ringbuffer_size = BLKVSC_RING_BUFFER_SIZE;
 
+module_param(blkvsc_ringbuffer_size, int, S_IRUGO);
+MODULE_PARM_DESC(ring_size, "Ring buffer size (in bytes)");
+
 /*
  * There is a circular dependency involving blkvsc_probe()
  * and block_ops.
@@ -1222,9 +1225,6 @@ static void blkvsc_request(struct request_queue *queue)
 }
 
 
-module_param(blkvsc_ringbuffer_size, int, S_IRUGO);
-MODULE_PARM_DESC(ring_size, "Ring buffer size (in bytes)");
-
 /* The one and only one */
 static  struct storvsc_driver_object g_blkvsc_drv;
 
-- 
1.7.4.1

