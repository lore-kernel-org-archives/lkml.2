Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab1CWSMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:12:09 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33138
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756243Ab1CWSLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:11:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 14/16] Staging: hv: Move the definition of the function put_stor_device()
Date: Wed, 23 Mar 2011 10:50:32 -0700
Message-Id: <1300902635-1347-14-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for further cleaning up storvsc.c move the definition
of the inline function put_stor_device() from storvsc.c to
storvsc_api.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c     |    9 ---------
 drivers/staging/hv/storvsc_api.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 357f5dd..c576e7b 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -71,15 +71,6 @@ static inline struct storvsc_device *must_get_stor_device(
 	return stor_device;
 }
 
-static inline void put_stor_device(struct hv_device *device)
-{
-	struct storvsc_device *stor_device;
-
-	stor_device = (struct storvsc_device *)device->ext;
-
-	atomic_dec(&stor_device->ref_count);
-}
-
 /* Drop ref count to 1 to effectively disable get_stor_device() */
 static inline struct storvsc_device *release_stor_device(
 					struct hv_device *device)
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 4e66507..d46b4de 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -152,6 +152,16 @@ static inline struct storvsc_device *get_stor_device(struct hv_device *device)
 	return stor_device;
 }
 
+
+static inline void put_stor_device(struct hv_device *device)
+{
+	struct storvsc_device *stor_device;
+
+	stor_device = (struct storvsc_device *)device->ext;
+
+	atomic_dec(&stor_device->ref_count);
+}
+
 /* Interface */
 int stor_vsc_on_host_reset(struct hv_device *device);
 
-- 
1.7.4.1

