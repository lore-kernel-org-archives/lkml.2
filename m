Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030868Ab2ERCzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:55:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40597 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030740Ab2ERCww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:52 -0400
Message-Id: <20120518023301.367441156@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 52/53] mtd: map.h: fix arm cross-build failure
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 4a42243886b87cd28a39b192161767c2af851a55 upstream.

This patch fixes the following build failure:
In file included from include/linux/mtd/qinfo.h:4:0,
                 from include/linux/mtd/pfow.h:7,
                 from drivers/mtd/lpddr/lpddr_cmds.c:27:
include/linux/mtd/map.h: In function 'inline_map_read':
include/linux/mtd/map.h:409:3: error: implicit declaration of function 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mtd/map.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 1132410..94e924e 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -26,7 +26,7 @@
 #include <linux/list.h>
 #include <linux/string.h>
 #include <linux/bug.h>
-
+#include <linux/kernel.h>
 
 #include <asm/unaligned.h>
 #include <asm/system.h>
-- 
1.7.10



