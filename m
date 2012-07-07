Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2GGVxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 17:53:45 -0400
Received: from nat.scz.novell.com ([213.151.88.252]:45677 "EHLO linux.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751725Ab2GGVxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:53:17 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jul 2012 17:53:16 EDT
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: Print errors to stderr in the Makefile
Date: Sat,  7 Jul 2012 23:42:34 +0200
Message-Id: <1341697354-36734-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/Makefile |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 7966265..b990e4f 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -234,12 +234,12 @@ $(obj)/.tmp_qtcheck:
 	        if [ -f $$d/include/qconfig.h ]; then dir=$$d; break; fi; \
 	      done; \
 	      if [ -z "$$dir" ]; then \
-	        echo "*"; \
-	        echo "* Unable to find any QT installation. Please make sure that"; \
-	        echo "* the QT4 or QT3 development package is correctly installed and"; \
-	        echo "* either qmake can be found or install pkg-config or set"; \
-	        echo "* the QTDIR environment variable to the correct location."; \
-	        echo "*"; \
+	        echo >&2 "*"; \
+	        echo >&2 "* Unable to find any QT installation. Please make sure that"; \
+	        echo >&2 "* the QT4 or QT3 development package is correctly installed and"; \
+	        echo >&2 "* either qmake can be found or install pkg-config or set"; \
+	        echo >&2 "* the QTDIR environment variable to the correct location."; \
+	        echo >&2 "*"; \
 	        false; \
 	      fi; \
 	      libpath=$$dir/lib; lib=qt; osdir=""; \
@@ -279,17 +279,17 @@ $(obj)/.tmp_gtkcheck:
 		if `pkg-config --atleast-version=2.0.0 gtk+-2.0`; then			\
 			touch $@;								\
 		else									\
-			echo "*"; 							\
-			echo "* GTK+ is present but version >= 2.0.0 is required.";	\
-			echo "*";							\
+			echo >&2 "*"; 							\
+			echo >&2 "* GTK+ is present but version >= 2.0.0 is required.";	\
+			echo >&2 "*";							\
 			false;								\
 		fi									\
 	else										\
-		echo "*"; 								\
-		echo "* Unable to find the GTK+ installation. Please make sure that"; 	\
-		echo "* the GTK+ 2.0 development package is correctly installed..."; 	\
-		echo "* You need gtk+-2.0, glib-2.0 and libglade-2.0."; 		\
-		echo "*"; 								\
+		echo >&2 "*"; 								\
+		echo >&2 "* Unable to find the GTK+ installation. Please make sure that"; 	\
+		echo >&2 "* the GTK+ 2.0 development package is correctly installed..."; 	\
+		echo >&2 "* You need gtk+-2.0, glib-2.0 and libglade-2.0."; 		\
+		echo >&2 "*"; 								\
 		false;									\
 	fi
 endif
-- 
1.7.8.3

