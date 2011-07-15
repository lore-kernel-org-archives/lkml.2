Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1GORkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:40:37 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37320
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754180Ab1GORaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:06 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 079/117] Staging: hv: storvsc: Cleanup alloc_stor_device()
Date: Fri, 15 Jul 2011 10:47:07 -0700
Message-Id: <1310752065-27895-79-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup alloc_stor_device(), we can set the ref_count directly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 313a3f8..48bd8da 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -42,7 +42,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 
 	/* Set to 2 to allow both inbound and outbound traffics */
 	/* (ie get_out_stor_device() and get_in_stor_device()) to proceed. */
-	atomic_cmpxchg(&stor_device->ref_count, 0, 2);
+	atomic_set(&stor_device->ref_count, 2);
 
 	init_waitqueue_head(&stor_device->waiting_to_drain);
 	stor_device->device = device;
-- 
1.7.4.1

