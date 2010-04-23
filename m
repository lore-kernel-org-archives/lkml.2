Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0DWX4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 19:56:37 -0400
Received: from weedy.perldition.org ([85.10.210.75]:55879 "EHLO
	weedy.perldition.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab0DWX4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 19:56:36 -0400
X-Greylist: delayed 1710 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2010 19:56:36 EDT
From: Florian Ragwitz <rafl@debian.org>
To: linux-kernel@vger.kernel.org
Cc: Florian Ragwitz <rafl@debian.org>
Subject: [PATCH] Fix DYNAMIC_DEBUG documentation errors.
Date: Sat, 24 Apr 2010 01:26:53 +0200
Message-Id: <1272065213-13677-1-git-send-email-rafl@debian.org>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Ragwitz <rafl@debian.org>
---
 include/linux/dynamic_debug.h |    2 +-
 lib/Kconfig.debug             |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index f8c2e17..3fc89c7 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -28,7 +28,7 @@ struct _ddebug {
 	/*
  	 * The flags field controls the behaviour at the callsite.
  	 * The bits here are changed dynamically when the user
- 	 * writes commands to <debugfs>/dynamic_debug/ddebug
+ 	 * writes commands to <debugfs>/dynamic_debug/control
 	 */
 #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
 #define _DPRINTK_FLAGS_DEFAULT 0
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 935248b..8556536 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1027,10 +1027,10 @@ config DYNAMIC_DEBUG
 
 	  Usage:
 
-	  Dynamic debugging is controlled via the 'dynamic_debug/ddebug' file,
+	  Dynamic debugging is controlled via the 'dynamic_debug/control' file,
 	  which is contained in the 'debugfs' filesystem. Thus, the debugfs
 	  filesystem must first be mounted before making use of this feature.
-	  We refer the control file as: <debugfs>/dynamic_debug/ddebug. This
+	  We refer the control file as: <debugfs>/dynamic_debug/control. This
 	  file contains a list of the debug statements that can be enabled. The
 	  format for each line of the file is:
 
@@ -1045,7 +1045,7 @@ config DYNAMIC_DEBUG
 
 	  From a live system:
 
-		nullarbor:~ # cat <debugfs>/dynamic_debug/ddebug
+		nullarbor:~ # cat <debugfs>/dynamic_debug/control
 		# filename:lineno [module]function flags format
 		fs/aio.c:222 [aio]__put_ioctx - "__put_ioctx:\040freeing\040%p\012"
 		fs/aio.c:248 [aio]ioctx_alloc - "ENOMEM:\040nr_events\040too\040high\012"
@@ -1055,23 +1055,23 @@ config DYNAMIC_DEBUG
 
 		// enable the message at line 1603 of file svcsock.c
 		nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 		// enable all the messages in file svcsock.c
 		nullarbor:~ # echo -n 'file svcsock.c +p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 		// enable all the messages in the NFS server module
 		nullarbor:~ # echo -n 'module nfsd +p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 		// enable all 12 messages in the function svc_process()
 		nullarbor:~ # echo -n 'func svc_process +p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 		// disable all 12 messages in the function svc_process()
 		nullarbor:~ # echo -n 'func svc_process -p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 	  See Documentation/dynamic-debug-howto.txt for additional information.
 
-- 
1.7.0.5

