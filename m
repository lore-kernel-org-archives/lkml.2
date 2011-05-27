Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab1E0Ion (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:44:43 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:49357 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758682Ab1E0Iok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:44:40 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: usbip-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] staging: usbip: userspace: use memset instead of bzero
Date: Fri, 27 May 2011 01:44:10 -0700
Message-Id: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bzero is and has been deprecated since POSIX.1-2001.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/configure.ac       |    4 ++--
 .../staging/usbip/userspace/libsrc/usbip_common.h  |    1 -
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |    2 +-
 .../staging/usbip/userspace/src/usbip_network.c    |    4 ++--
 drivers/staging/usbip/userspace/src/usbipd.c       |   14 +++++++-------
 drivers/staging/usbip/userspace/src/utils.c        |    2 +-
 6 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index e7d801b..06fb95d 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -29,7 +29,7 @@ AC_PROG_MAKE_SET
 AC_HEADER_DIRENT
 AC_HEADER_STDC
 AC_CHECK_HEADERS([arpa/inet.h fcntl.h netdb.h netinet/in.h stdint.h stdlib.h dnl
-		  string.h strings.h sys/socket.h syslog.h unistd.h])
+		  string.h sys/socket.h syslog.h unistd.h])
 
 # Checks for typedefs, structures, and compiler characteristics.
 AC_TYPE_INT32_T
@@ -41,7 +41,7 @@ AC_TYPE_UINT8_T
 
 # Checks for library functions.
 AC_FUNC_REALLOC
-AC_CHECK_FUNCS([bzero memset mkdir regcomp socket strchr strerror strstr dnl
+AC_CHECK_FUNCS([memset mkdir regcomp socket strchr strerror strstr dnl
 		strtoul])
 
 AC_CHECK_HEADER([sysfs/libsysfs.h],
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 2c58af5..b38396f 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -12,7 +12,6 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <strings.h>
 
 #include <sysfs/libsysfs.h>
 #include <netdb.h>
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index f2030b1..386f63b 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -52,7 +52,7 @@ static int parse_status(char *value)
 
 
 	for (int i = 0; i < vhci_driver->nports; i++)
-		bzero(&vhci_driver->idev[i], sizeof(struct usbip_imported_device));
+		memset(&vhci_driver->idev[i], 0, sizeof(vhci_driver->idev[i]));
 
 
 	/* skip a header line */
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index ef93b02..0e0de56 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -100,7 +100,7 @@ int usbip_send_op_common(int sockfd, uint32_t code, uint32_t status)
 	int ret;
 	struct op_common op_common;
 
-	bzero(&op_common, sizeof(op_common));
+	memset(&op_common, 0, sizeof(op_common));
 
 	op_common.version	= USBIP_VERSION;
 	op_common.code		= code;
@@ -122,7 +122,7 @@ int usbip_recv_op_common(int sockfd, uint16_t *code)
 	int ret;
 	struct op_common op_common;
 
-	bzero(&op_common, sizeof(op_common));
+	memset(&op_common, 0, sizeof(op_common));
 
 	ret = usbip_recv(sockfd, (void *) &op_common, sizeof(op_common));
 	if (ret < 0) {
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index ccc7dfd..12ff00b 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -10,7 +10,7 @@
 #include <errno.h>
 #include <unistd.h>
 #include <netdb.h>
-#include <strings.h>
+#include <string.h>
 #include <stdlib.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -100,7 +100,7 @@ static int recv_request_devlist(int sockfd)
 	int ret;
 	struct op_devlist_request req;
 
-	bzero(&req, sizeof(req));
+	memset(&req, 0, sizeof(req));
 
 	ret = usbip_recv(sockfd, (void *) &req, sizeof(req));
 	if (ret < 0) {
@@ -127,8 +127,8 @@ static int recv_request_import(int sockfd)
 	int found = 0;
 	int error = 0;
 
-	bzero(&req, sizeof(req));
-	bzero(&reply, sizeof(reply));
+	memset(&req, 0, sizeof(req));
+	memset(&reply, 0, sizeof(reply));
 
 	ret = usbip_recv(sockfd, (void *) &req, sizeof(req));
 	if (ret < 0) {
@@ -244,7 +244,7 @@ static struct addrinfo *my_getaddrinfo(char *host, int ai_family)
 	int ret;
 	struct addrinfo hints, *ai_head;
 
-	bzero(&hints, sizeof(hints));
+	memset(&hints, 0, sizeof(hints));
 
 	hints.ai_family   = ai_family;
 	hints.ai_socktype = SOCK_STREAM;
@@ -337,7 +337,7 @@ static int my_accept(int lsock)
 	char host[NI_MAXHOST], port[NI_MAXSERV];
 	int ret;
 
-	bzero(&ss, sizeof(ss));
+	memset(&ss, 0, sizeof(ss));
 
 	csock = accept(lsock, (struct sockaddr *) &ss, &len);
 	if (csock < 0) {
@@ -380,7 +380,7 @@ static void set_signal(void)
 {
 	struct sigaction act;
 
-	bzero(&act, sizeof(act));
+	memset(&act, 0, sizeof(act));
 	act.sa_handler = signal_handler;
 	sigemptyset(&act.sa_mask);
 	sigaction(SIGTERM, &act, NULL);
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 6f91557..35b05e4 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -64,7 +64,7 @@ int read_integer(char *path)
 	int fd;
 	int ret = 0;
 
-	bzero(buff, sizeof(buff));
+	memset(buff, 0, sizeof(buff));
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
-- 
1.7.5.1

