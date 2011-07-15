Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1GORhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:37:52 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33330
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754216Ab1GORaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 083/117] Staging: hv: storvsc: Prevent outgoing traffic when stor dev is destroyed
Date: Fri, 15 Jul 2011 10:47:11 -0700
Message-Id: <1310752065-27895-83-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent outgoing traffic when stor dev is destroyed.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index 6b20f1d..53b65be 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -296,7 +296,8 @@ static inline struct storvsc_device *get_out_stor_device(
 
 	spin_lock_irqsave(&device->ext_lock, flags);
 	stor_device = (struct storvsc_device *)device->ext;
-	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
+	if (stor_device && (atomic_read(&stor_device->ref_count) > 1) &&
+		!stor_device->destroy)
 		atomic_inc(&stor_device->ref_count);
 	else
 		stor_device = NULL;
-- 
1.7.4.1

