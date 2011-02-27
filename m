Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1B0QCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:02:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:58583 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab1B0QCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:02:04 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 12/17] unicore32 i8042 upgrade and bugfix: adjust resource request region type
Date: Sun, 27 Feb 2011 15:59:40 +0000
Message-Id: <d6ef0772047039db27898490f37d1228d164314a.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 drivers/input/serio/i8042-unicore32io.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/i8042-unicore32io.h b/drivers/input/serio/i8042-unicore32io.h
index 2cdd872..620b040 100644
--- a/drivers/input/serio/i8042-unicore32io.h
+++ b/drivers/input/serio/i8042-unicore32io.h
@@ -58,7 +58,7 @@ static inline void i8042_write_command(int val)
 
 static inline int i8042_platform_init(void)
 {
-	if (!request_region(I8042_REGION_START, I8042_REGION_SIZE, "i8042"))
+	if (!request_mem_region(I8042_REGION_START, I8042_REGION_SIZE, "i8042"))
 		return -EBUSY;
 
 	i8042_reset = 1;
@@ -67,7 +67,7 @@ static inline int i8042_platform_init(void)
 
 static inline void i8042_platform_exit(void)
 {
-	release_region(I8042_REGION_START, I8042_REGION_SIZE);
+	release_mem_region(I8042_REGION_START, I8042_REGION_SIZE);
 }
 
 #endif /* _I8042_UNICORE32_H */
-- 
1.7.4.1

