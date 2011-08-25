Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1HYQj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:39:26 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42762
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753455Ab1HYQ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:56 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 25/59] Staging: hv: vmbus: Cleanup error handling in hv_init()
Date: Thu, 25 Aug 2011 09:48:51 -0700
Message-Id: <1314290965-2698-25-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux error codes.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index d2b921b..736794e 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -151,7 +151,6 @@ static u64 do_hypercall(u64 control, void *input, void *output)
  */
 int hv_init(void)
 {
-	int ret = 0;
 	int max_leaf;
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 	void *virtaddr = NULL;
@@ -214,7 +213,7 @@ int hv_init(void)
 	hv_context.signal_event_param->flag_number = 0;
 	hv_context.signal_event_param->rsvdz = 0;
 
-	return ret;
+	return 0;
 
 cleanup:
 	if (virtaddr) {
@@ -225,8 +224,8 @@ cleanup:
 
 		vfree(virtaddr);
 	}
-	ret = -1;
-	return ret;
+
+	return -ENOTSUPP;
 }
 
 /*
-- 
1.7.4.1

