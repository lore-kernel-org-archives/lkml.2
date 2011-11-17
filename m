Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1KQXed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:34:33 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:58950 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab1KQXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:34:32 -0500
From: Richard Weinberger <richard@nod.at>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
Date: Fri, 18 Nov 2011 00:34:24 +0100
Message-Id: <1321572864-23628-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi_dh_attach() should return a negative value on error.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/scsi/scsi_dh.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index e3f2db2..e07ab10 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const char *name)
 }
 static inline int scsi_dh_attach(struct request_queue *req, const char *name)
 {
-	return SCSI_DH_NOSYS;
+	return -SCSI_DH_NOSYS;
 }
 static inline void scsi_dh_detach(struct request_queue *q)
 {
-- 
1.7.7.3

