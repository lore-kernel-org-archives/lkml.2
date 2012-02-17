Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2BQXjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:39:36 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44441 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2BQXjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:39:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.236.182.36 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
From: Jorgyano Vieira <jorgyano@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        nsankar@broadcom.com, jarod@wilsonet.com,
        Jorgyano Vieira <jorgyano@gmail.com>
Subject: [PATCH 2/3] Staging: crystalhd: Get rid of unecessary BCMLOG_ENTER macro
Date: Fri, 17 Feb 2012 21:38:09 -0200
Message-Id: <1329521889-1260-1-git-send-email-jorgyano@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCMLOG_ENTER macro is used only in five functions, perhaps
it is remainder of debugging some specific problem,
now, this macro don't seems to be useful, so it should be removed.

Signed-off-by: Jorgyano Vieira <jorgyano@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_hw.c   |    3 ---
 drivers/staging/crystalhd/crystalhd_lnx.c  |    4 ----
 drivers/staging/crystalhd/crystalhd_misc.h |    7 -------
 3 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index eeddee9..2d02ed2 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -1627,7 +1627,6 @@ enum BC_STATUS crystalhd_download_fw(struct crystalhd_adp *adp, void *buffer, ui
 	uint32_t fw_sig_len = 36;
 	uint32_t dram_offset = BC_FWIMG_ST_ADDR, sig_reg;
 
-	BCMLOG_ENTER;
 
 	if (!adp || !buffer || !sz) {
 		BCMLOG_ERR("Invalid Params.\n");
@@ -1724,8 +1723,6 @@ enum BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw,
 
 	crystalhd_create_event(&fw_cmd_event);
 
-	BCMLOG_ENTER;
-
 	if (!hw || !fw_cmd) {
 		BCMLOG_ERR("Invalid Arguments\n");
 		return BC_STS_INV_ARG;
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 7e0c199..9dca92c 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -298,7 +298,6 @@ static int chd_dec_open(struct inode *in, struct file *fd)
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 	struct crystalhd_user *uc = NULL;
 
-	BCMLOG_ENTER;
 	if (!adp) {
 		BCMLOG_ERR("Invalid adp\n");
 		return -EINVAL;
@@ -327,7 +326,6 @@ static int chd_dec_close(struct inode *in, struct file *fd)
 	struct crystalhd_adp *adp = chd_get_adp();
 	struct crystalhd_user *uc;
 
-	BCMLOG_ENTER;
 	if (!adp) {
 		BCMLOG_ERR("Invalid adp\n");
 		return -EINVAL;
@@ -513,8 +511,6 @@ static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
 	struct crystalhd_adp *pinfo;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
-	BCMLOG_ENTER;
-
 	pinfo = pci_get_drvdata(pdev);
 	if (!pinfo) {
 		BCMLOG_ERR("could not get adp\n");
diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index eedd9b7..d2f7256 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -200,15 +200,8 @@ enum _chd_log_levels {
 	BCMLOG_INFO		= 0x00000001,	/* Generic informational */
 	BCMLOG_DBG		= 0x00000002,	/* First level Debug info */
 	BCMLOG_SSTEP		= 0x00000004,	/* Stepping information */
-	BCMLOG_ENTER_LEAVE	= 0x00000008,	/* stack tracking */
 };
 
-#define BCMLOG_ENTER						\
-do {								\
-	if (g_linklog_level & BCMLOG_ENTER_LEAVE)		\
-		printk(KERN_DEBUG "Entered %s\n", __func__);	\
-} while (0)
-
 
 #define BCMLOG(trace, fmt, args...)	\
 do {					\
-- 
1.7.2.5

