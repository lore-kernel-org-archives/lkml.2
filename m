Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1H0SLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:50 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39827
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751474Ab1H0SLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 07/46] Staging: hv: storvsc: Prevent outgoing traffic when stor dev is being destroyed
Date: Sat, 27 Aug 2011 11:31:06 -0700
Message-Id: <1314469905-7058-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
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
index d93bf93..1a59ca0 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -294,7 +294,8 @@ static inline struct storvsc_device *get_out_stor_device(
 	struct storvsc_device *stor_device;
 
 	stor_device = (struct storvsc_device *)device->ext;
-	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
+	if (stor_device && (atomic_read(&stor_device->ref_count) > 1) &&
+		!stor_device->destroy)
 		atomic_inc(&stor_device->ref_count);
 	else
 		stor_device = NULL;
-- 
1.7.4.1

