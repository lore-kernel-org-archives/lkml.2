Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2LBDS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 22:18:58 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40304 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2LBDS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 22:18:56 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        megaraidlinux@lsi.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH 4/6] scsi: megaraid: remove a useless call to memset().
Date: Sun,  2 Dec 2012 03:40:20 +0100
Message-Id: <1354416022-20189-5-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
References: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call is followed by a call to memcpy() on the same memory area, so it can
be safely removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 74030af..71cc3eb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1028,8 +1028,6 @@ map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
 
 		cmd->scmd->result = (DID_OK << 16) | ext_status;
 		if (ext_status == SAM_STAT_CHECK_CONDITION) {
-			memset(cmd->scmd->sense_buffer, 0,
-			       SCSI_SENSE_BUFFERSIZE);
 			memcpy(cmd->scmd->sense_buffer, cmd->sense,
 			       SCSI_SENSE_BUFFERSIZE);
 			cmd->scmd->result |= DRIVER_SENSE << 24;
-- 
1.7.10.4

