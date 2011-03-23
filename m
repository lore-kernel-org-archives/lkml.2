Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab1CWRmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:42:37 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58423
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756119Ab1CWRkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:39 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 13/16] Staging: hv: Move the definition of the function get_stor_device()
Date: Wed, 23 Mar 2011 10:50:31 -0700
Message-Id: <1300902635-1347-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for further cleaning up storvsc.c move the definition 
of the inline function get_stor_device() from storvsc.c to 
storvsc_api.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c     |   14 --------------
 drivers/staging/hv/storvsc_api.h |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 83d012b..357f5dd 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -56,20 +56,6 @@ static inline void free_stor_device(struct storvsc_device *device)
 	kfree(device);
 }
 
-/* Get the stordevice object iff exists and its refcount > 1 */
-static inline struct storvsc_device *get_stor_device(struct hv_device *device)
-{
-	struct storvsc_device *stor_device;
-
-	stor_device = (struct storvsc_device *)device->ext;
-	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
-		atomic_inc(&stor_device->ref_count);
-	else
-		stor_device = NULL;
-
-	return stor_device;
-}
-
 /* Get the stordevice object iff exists and its refcount > 0 */
 static inline struct storvsc_device *must_get_stor_device(
 					struct hv_device *device)
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index d985bbf..4e66507 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -137,6 +137,21 @@ struct storvsc_device {
 	struct storvsc_request_extension reset_request;
 };
 
+
+/* Get the stordevice object iff exists and its refcount > 1 */
+static inline struct storvsc_device *get_stor_device(struct hv_device *device)
+{
+	struct storvsc_device *stor_device;
+
+	stor_device = (struct storvsc_device *)device->ext;
+	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
+		atomic_inc(&stor_device->ref_count);
+	else
+		stor_device = NULL;
+
+	return stor_device;
+}
+
 /* Interface */
 int stor_vsc_on_host_reset(struct hv_device *device);
 
-- 
1.7.4.1

