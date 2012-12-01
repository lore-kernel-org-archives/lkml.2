Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2LAO2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:28:55 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35031
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab2LAO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:28:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 13/28] Drivers: hv: Move vmbus version definitions to hyperv.h
Date: Sat,  1 Dec 2012 06:46:44 -0800
Message-Id: <1354373219-31374-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support version specific optimization in various vmbus drivers,
move the vmbus definitions to the public header file.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c |   15 ---------------
 include/linux/hyperv.h  |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 0d8b132..56b14e5 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -41,21 +41,6 @@ struct vmbus_connection vmbus_connection = {
 };
 
 /*
- * VMBUS version is 32 bit entity broken up into
- * two 16 bit quantities: major_number. minor_number.
- *
- * 0 . 13 (Windows Server 2008)
- * 1 . 1  (Windows 7)
- * 2 . 4  (Windows 8)
- */
-
-#define VERSION_WS2008	((0 << 16) | (13))
-#define VERSION_WIN7	((1 << 16) | (1))
-#define VERSION_WIN8	((2 << 16) | (4))
-
-#define VERSION_INVAL -1
-
-/*
  * Negotiated protocol version with the host.
  */
 __u32 vmbus_proto_version;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 134a202..e725026 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -419,6 +419,21 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
  */
 #define HV_DRV_VERSION           "3.1"
 
+/*
+ * VMBUS version is 32 bit entity broken up into
+ * two 16 bit quantities: major_number. minor_number.
+ *
+ * 0 . 13 (Windows Server 2008)
+ * 1 . 1  (Windows 7)
+ * 2 . 4  (Windows 8)
+ */
+
+#define VERSION_WS2008  ((0 << 16) | (13))
+#define VERSION_WIN7    ((1 << 16) | (1))
+#define VERSION_WIN8    ((2 << 16) | (4))
+
+#define VERSION_INVAL -1
+
 
 /* Make maximum size of pipe payload of 16K */
 #define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)
-- 
1.7.4.1

