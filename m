Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2FLNX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab2FLNXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:23:47 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 5/5] sb_edac: properly handle error count
Date: Tue, 12 Jun 2012 10:23:31 -0300
Message-Id: <99eb967b04f2fc458a744d57d1142299a71830e1.1339507096.git.mchehab@redhat.com>
In-Reply-To: <cover.1339507094.git.mchehab@redhat.com>
References: <cover.1339507094.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reporting the error count via driver-specific details,
use the new way provided by edac_mc_handle_error.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/sb_edac.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 2809b07..6f88613 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1432,8 +1432,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	 * to the group of dimm's where the error may be happening.
 	 */
 	snprintf(msg, sizeof(msg),
-		 "count:%d%s%s area:%s err_code:%04x:%04x socket:%d channel_mask:%ld rank:%d",
-		 core_err_cnt,
+		 "%s%s area:%s err_code:%04x:%04x socket:%d channel_mask:%ld rank:%d",
 		 overflow ? " OVERFLOW" : "",
 		 (uncorrected_error && recoverable) ? " recoverable" : "",
 		 area_type,
@@ -1447,13 +1446,13 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	/* FIXME: need support for channel mask */
 
 	/* Call the helper to output message */
-	edac_mc_handle_error(tp_event, mci, 1,
+	edac_mc_handle_error(tp_event, mci, core_err_cnt,
 			     m->addr >> PAGE_SHIFT, m->addr & ~PAGE_MASK, 0,
 			     channel, dimm, -1,
 			     optype, msg);
 	return;
 err_parsing:
-	edac_mc_handle_error(tp_event, mci, 1, 0, 0, 0,
+	edac_mc_handle_error(tp_event, mci, core_err_cnt, 0, 0, 0,
 			     -1, -1, -1,
 			     msg, "");
 
-- 
1.7.10.2

