Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1H0SLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:30 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54786
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751470Ab1H0SLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 22/46] Staging: hv: storvsc: Optimize the bounce buffer handling in the "read" case
Date: Sat, 27 Aug 2011 11:31:21 -0700
Message-Id: <1314469905-7058-22-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize the bounce buffer handling in the "read" case.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 90b91ad..3e00e70 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -560,12 +560,10 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 				ALIGN(scsi_bufflen(scmnd), PAGE_SIZE) >>
 					PAGE_SHIFT;
 
-			/*
-			 * FIXME: We can optimize on reads by just skipping
-			 * this
-			 */
-			copy_to_bounce_buffer(sgl, cmd_request->bounce_sgl,
-					      scsi_sg_count(scmnd));
+			if (vm_srb->data_in == WRITE_TYPE)
+				copy_to_bounce_buffer(sgl,
+					cmd_request->bounce_sgl,
+					scsi_sg_count(scmnd));
 
 			sgl = cmd_request->bounce_sgl;
 			sg_count = cmd_request->bounce_sgl_count;
-- 
1.7.4.1

