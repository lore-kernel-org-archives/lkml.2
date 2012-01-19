Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2ASOP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:15:29 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:52325 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2ASOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:15:27 -0500
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 09:15:27 EST
X-Spam-Score: -4.4
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux@dominikbrodowski.net
Subject: [PATCH] cpupower: Fix linking with --as-needed
Date: Thu, 19 Jan 2012 16:06:36 +0200
Message-Id: <1326981996-17842-1-git-send-email-ozan@pardus.org.tr>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix linking order to avoid undefined reference errors when
using --as-needed linker flag.

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 tools/power/cpupower/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/power/cpupower/Makefile b/tools/power/cpupower/Makefile
index e8a03ac..f01b3f5 100644
--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -193,7 +193,7 @@ $(UTIL_OBJS): $(UTIL_HEADERS)
 
 cpupower: $(UTIL_OBJS) libcpupower.so.$(LIB_MAJ)
 	$(ECHO) "  CC      " $@
-	$(QUIET) $(CC) $(CFLAGS) $(LDFLAGS) -lcpupower -lrt -lpci -L. -o $@ $(UTIL_OBJS)
+	$(QUIET) $(CC) $(CFLAGS) $(LDFLAGS) $(UTIL_OBJS) -lcpupower -lrt -lpci -L. -o $@
 	$(QUIET) $(STRIPCMD) $@
 
 po/$(PACKAGE).pot: $(UTIL_SRC)
-- 
1.7.7.1

