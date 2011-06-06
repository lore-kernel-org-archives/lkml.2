Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab1FFWhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:37:47 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37312
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758205Ab1FFWfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 45/49] Staging: hv: vmbus: Cleanup error codes in hv.c
Date: Mon,  6 Jun 2011 15:50:09 -0700
Message-Id: <1307400613-13234-45-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup error codes in hv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/hv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index a2cc091..824f816 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -277,11 +277,11 @@ u16 hv_post_message(union hv_connection_id connection_id,
 	unsigned long addr;
 
 	if (payload_size > HV_MESSAGE_PAYLOAD_BYTE_COUNT)
-		return -1;
+		return -EMSGSIZE;
 
 	addr = (unsigned long)kmalloc(sizeof(struct aligned_input), GFP_ATOMIC);
 	if (!addr)
-		return -1;
+		return -ENOMEM;
 
 	aligned_msg = (struct hv_input_post_message *)
 			(ALIGN(addr, HV_HYPERCALL_PARAM_ALIGN));
-- 
1.7.4.1

