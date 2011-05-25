Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1EYJJZ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 25 May 2011 05:09:25 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57239 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1EYJJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:09:24 -0400
From: y@borg.net
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] include/linux/printk.h is not self-contained
Date: Wed, 25 May 2011 11:09:14 +0200
Message-Id: <1306314554-19198-1-git-send-email-y>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

<linux/printk.h> needs to include
  - <stdarg.h> for "va_list",
  - <linux/linkage.h> for "asmlinkage",
  - <linux/types.h> for "bool".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/printk.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..6388bc8 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -1,6 +1,10 @@
 #ifndef __KERNEL_PRINTK__
 #define __KERNEL_PRINTK__
 
+#include <stdarg.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-- 
1.7.0.4

