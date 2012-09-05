Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2IEKDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:03:09 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:37378 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758435Ab2IEJ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:52 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 12/17] mfd: prcmu: make fw_project_name generic
Date: Wed, 5 Sep 2012 11:59:08 +0200
Message-ID: <1346839153-6465-13-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Project_name_id must be increased to support 8500 and x540 project.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |  4 +++-
 include/linux/mfd/db8500-prcmu.h | 14 --------------
 include/linux/mfd/dbx500-prcmu.h | 17 +++++++++++++++++
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 96487a0..327e9f6 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2335,7 +2335,7 @@ static struct irq_chip prcmu_irq_chip = {
 	.irq_unmask	= prcmu_irq_unmask,
 };
 
-static char *fw_project_name(u8 project)
+char *fw_project_name(u32 project)
 {
 	switch (project) {
 	case PRCMU_FW_PROJECT_U8500:
@@ -2350,6 +2350,8 @@ static char *fw_project_name(u8 project)
 		return "U8520";
 	case PRCMU_FW_PROJECT_U8420:
 		return "U8420";
+	case PRCMU_FW_PROJECT_U9540:
+		return "U9540";
 	default:
 		return "Unknown";
 	}
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index a6d7298..f3b8b60 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -470,20 +470,6 @@ struct prcmu_auto_pm_config {
 	u8 sva_policy;
 };
 
-#define PRCMU_FW_PROJECT_U8500		2
-#define PRCMU_FW_PROJECT_U9500		4
-#define PRCMU_FW_PROJECT_U8500_C2	7
-#define PRCMU_FW_PROJECT_U9500_C2	11
-#define PRCMU_FW_PROJECT_U8520		13
-#define PRCMU_FW_PROJECT_U8420		14
-
-struct prcmu_fw_version {
-	u8 project;
-	u8 api_version;
-	u8 func_version;
-	u8 errata;
-};
-
 #ifdef CONFIG_MFD_DB8500_PRCMU
 
 struct prcmu_fops_register_data *db8500_prcmu_early_init(
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index d76114e..49e71a7 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -235,6 +235,23 @@ struct prcmu_tcdm_map {
 	u32 legacy_offset;
 };
 
+#define PRCMU_FW_PROJECT_U8500		2
+#define PRCMU_FW_PROJECT_U9500		4 /* Customer specific */
+#define PRCMU_FW_PROJECT_U8500_C2	7
+#define PRCMU_FW_PROJECT_U9500_C2	11 /* Customer specific */
+#define PRCMU_FW_PROJECT_U8520		13
+#define PRCMU_FW_PROJECT_U8420		14
+#define PRCMU_FW_PROJECT_U9540		(6<<8)
+
+#define PRCMU_FW_PROJECT_NAME_LEN	20
+struct prcmu_fw_version {
+	u8 project;
+	u8 api_version;
+	u8 func_version;
+	u8 errata;
+	char project_name[PRCMU_FW_PROJECT_NAME_LEN];
+};
+
 #include <linux/mfd/db8500-prcmu.h>
 
 #if defined(CONFIG_UX500_SOC_DB8500)
-- 
1.7.11.1

