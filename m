Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab1H0SLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:09 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54707
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750989Ab1H0SLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:07 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 03/46] Staging: hv: storvsc: Rename must_get_stor_device()
Date: Sat, 27 Aug 2011 11:31:02 -0700
Message-Id: <1314469905-7058-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for cleaning up how we manage reference counts on the stor
device, clearly distinguish why we are attempting to acquire a reference.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index cd38cd6..89708b1 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -41,7 +41,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffics */
-	/* (ie get_stor_device() and must_get_stor_device()) to proceed. */
+	/* (ie get_stor_device() and get_in_stor_device()) to proceed. */
 	atomic_cmpxchg(&stor_device->ref_count, 0, 2);
 
 	init_waitqueue_head(&stor_device->waiting_to_drain);
@@ -53,7 +53,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 
 
 /* Get the stordevice object iff exists and its refcount > 0 */
-static inline struct storvsc_device *must_get_stor_device(
+static inline struct storvsc_device *get_in_stor_device(
 					struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
@@ -305,7 +305,7 @@ static void storvsc_on_channel_callback(void *context)
 	int ret;
 
 
-	stor_device = must_get_stor_device(device);
+	stor_device = get_in_stor_device(device);
 	if (!stor_device)
 		return;
 
-- 
1.7.4.1

