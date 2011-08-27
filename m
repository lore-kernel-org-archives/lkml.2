Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1H0SNJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:13:09 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:55132
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751669Ab1H0SLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:23 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 30/46] Staging: hv: storvsc: No need to copy from bounce buffer in case of a failure
Date: Sat, 27 Aug 2011 11:31:29 -0700
Message-Id: <1314469905-7058-30-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to copy from bounce buffer in case of a failure; cleanup the code
accordingly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 22a1d75..d575bc9 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1315,17 +1315,9 @@ retry_request:
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
-					      cmd_request->bounce_sgl_count);
-		}
+					cmd_request->bounce_sgl_count);
 
 		kmem_cache_free(host_dev->request_pool, cmd_request);
 
-- 
1.7.4.1

