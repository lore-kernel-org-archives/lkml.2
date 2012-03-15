Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032387Ab2COVkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:40:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58759 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032342Ab2COVkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:40:45 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: andrew.vasquez@qlogic.com, nab@kernel.org
Cc: linux-driver@qlogic.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: fix section mismatch in linux-next
Date: Thu, 15 Mar 2012 14:40:26 -0700
Message-Id: <1331847626-11141-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qla_tgt_exit() is annotated __exit , but called in
qla2x00_module_init().

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 drivers/scsi/qla2xxx/qla_target.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6d6f1cf..699d16e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4730,7 +4730,7 @@ out:
 	return ret;
 }
 
-void __exit qla_tgt_exit(void)
+void qla_tgt_exit(void)
 {
 	destroy_workqueue(qla_tgt_wq);
 	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index db6b399..b9d0aa1 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -934,7 +934,7 @@ extern void qla_tgt_fc_port_deleted(struct scsi_qla_host *, fc_port_t *);
 extern void qla_tgt_set_mode(struct scsi_qla_host *ha);
 extern void qla_tgt_clear_mode(struct scsi_qla_host *ha);
 extern int __init qla_tgt_init(void);
-extern void __exit qla_tgt_exit(void);
+extern void qla_tgt_exit(void);
 
 static inline bool qla_tgt_mode_enabled(struct scsi_qla_host *ha)
 {
-- 
1.7.7.6

