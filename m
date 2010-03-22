Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0CVMYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:24:03 -0400
Received: from vps.mortis.eu ([79.99.135.181]:36177 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0CVMYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:24:01 -0400
From: Giel van Schijndel <me@mortis.eu>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Giel van Schijndel <me@mortis.eu>
Subject: [PATCH] doc: watchdog simple example: don't fail on fsync()
Date: Mon, 22 Mar 2010 13:22:37 +0100
Message-Id: <1269260557-18150-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't terminate the watchdog daemon when fsync() fails because no
watchdog driver actually implements the fsync() syscall.
---
 Documentation/watchdog/src/watchdog-simple.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/watchdog/src/watchdog-simple.c b/Documentation/watchdog/src/watchdog-simple.c
index 4cf72f3..cd6d0dd 100644
--- a/Documentation/watchdog/src/watchdog-simple.c
+++ b/Documentation/watchdog/src/watchdog-simple.c
@@ -1,3 +1,4 @@
+#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -18,7 +19,9 @@ int main(void)
 			break;
 		}
 		ret = fsync(fd);
-		if (ret)
+		if (ret
+		 && errno != EINVAL
+		 && errno != ENOSYS)
 			break;
 		sleep(10);
 	}
-- 
1.6.4.4

