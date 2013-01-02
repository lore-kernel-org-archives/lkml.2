Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3ABNgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:36:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44497 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691Ab3ABNg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:36:28 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] vfs: Add missing errno.h inclusion to namei.h
Date: Wed,  2 Jan 2013 13:36:26 +0000
Message-Id: <1357133786-29587-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current -next namei.h now include/linux/namei.h uses ESTALE but does
not include errno.h, leading to build failures on ARM where errno.h is
not previously implicitly included by some other header as is the case
in some bits of ext3. Fix this by adding a direct inclusion of errno.h.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/namei.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index e998c03..5a5ff57 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -2,6 +2,7 @@
 #define _LINUX_NAMEI_H
 
 #include <linux/dcache.h>
+#include <linux/errno.h>
 #include <linux/linkage.h>
 #include <linux/path.h>
 
-- 
1.7.10.4

