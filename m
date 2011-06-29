Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1F2OZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:25:52 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51199
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756124Ab1F2OW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:56 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 40/40] Staging: hv: storvsc: No need to copy from bounce buffer in case of failure
Date: Wed, 29 Jun 2011 07:39:37 -0700
Message-Id: <1309358377-8537-40-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case we are not able to submit an I/O, there is no need to copy
from the bounce buffers; get of the code to copy.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index cc4b128..e2cdd7b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1421,17 +1421,9 @@ retry_request:
 	if (ret == -EAGAIN) {
 		/* no more space */
 
-		if (cmd_request->bounce_sgl_count) {
-			/*
-			 * FIXME: We can optimize on writes by just skipping
-			 * this
-			 */
-			copy_from_bounce_buffer(scsi_sglist(scmnd),
-						cmd_request->bounce_sgl,
-						scsi_sg_count(scmnd));
+		if (cmd_request->bounce_sgl_count)
 			destroy_bounce_buffer(cmd_request->bounce_sgl,
 					      cmd_request->bounce_sgl_count);
-		}
 
 		kmem_cache_free(host_dev->request_pool, cmd_request);
 
-- 
1.7.4.1

