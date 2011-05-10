Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1EJSUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:20:30 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60626 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab1EJSU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:20:28 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/4] um: fix UML_LIB_PATH
Date: Tue, 10 May 2011 20:18:55 +0200
Message-Id: <1305051538-7191-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML_LIB_PATH is hardcoded to /usr/lib/uml/,
on 64bit systems UML_LIB_PATH needs to be /usr/lib64/uml/.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/xterm.c     |    2 +-
 arch/um/include/shared/os.h |    6 ++++++
 arch/um/os-Linux/main.c     |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index da2caa5..8ac7146 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -90,7 +90,7 @@ static int xterm_open(int input, int output, int primary, void *d,
 	int pid, fd, new, err;
 	char title[256], file[] = "/tmp/xterm-pipeXXXXXX";
 	char *argv[] = { terminal_emulator, title_switch, title, exec_switch,
-			 "/usr/lib/uml/port-helper", "-uml-socket",
+			 OS_LIB_PATH "/uml/port-helper", "-uml-socket",
 			 file, NULL };
 
 	if (access(argv[4], X_OK) < 0)
diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index c4617ba..f06a5da 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -29,6 +29,12 @@
 #define OS_ACC_R_OK    4       /* Test for read permission.  */
 #define OS_ACC_RW_OK   (OS_ACC_W_OK | OS_ACC_R_OK) /* Test for RW permission */
 
+#ifdef CONFIG_64BIT
+#define OS_LIB_PATH	"/usr/lib64/"
+#else
+#define OS_LIB_PATH	"/usr/lib/"
+#endif
+
 /*
  * types taken from stat_file() in hostfs_user.c
  * (if they are wrong here, they are wrong there...).
diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index eee69b9..39613ea 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -78,7 +78,7 @@ static void install_fatal_handler(int sig)
 	}
 }
 
-#define UML_LIB_PATH	":/usr/lib/uml"
+#define UML_LIB_PATH	":" OS_LIB_PATH "/uml"
 
 static void setup_env_path(void)
 {
-- 
1.7.4.2

