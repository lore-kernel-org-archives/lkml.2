Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2HQOg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:36:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35362 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2HQOfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:35:55 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 3/8] UBI: introduce MTD_PARAM_MAX_COUNT
Date: Fri, 17 Aug 2012 16:35:19 +0200
Message-Id: <1345214124-5478-4-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/build.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 82d11e1..1f45f51 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -46,6 +46,9 @@
 /* Maximum length of the 'mtd=' parameter */
 #define MTD_PARAM_LEN_MAX 64
 
+/* Maximum number of comma-separated items in ht 'mtd=' parameter */
+#define MTD_PARAM_MAX_COUNT 2
+
 #ifdef CONFIG_MTD_UBI_MODULE
 #define ubi_is_module() 1
 #else
@@ -1327,7 +1330,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	struct mtd_dev_param *p;
 	char buf[MTD_PARAM_LEN_MAX];
 	char *pbuf = &buf[0];
-	char *tokens[2] = {NULL, NULL};
+	char *tokens[MTD_PARAM_MAX_COUNT];
 
 	if (!val)
 		return -EINVAL;
@@ -1357,7 +1360,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	if (buf[len - 1] == '\n')
 		buf[len - 1] = '\0';
 
-	for (i = 0; i < 2; i++)
+	for (i = 0; i < MTD_PARAM_MAX_COUNT; i++)
 		tokens[i] = strsep(&pbuf, ",");
 
 	if (pbuf) {
-- 
1.7.2.5

