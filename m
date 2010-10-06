Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab0JFHmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:42:40 -0400
Received: from www.wytron.com.tw ([211.75.82.101]:49259 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab0JFHmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:42:39 -0400
X-Greylist: delayed 1792 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2010 03:42:39 EDT
From: Thomas Chou <thomas@wytron.com.tw>
To: linux-kernel@vger.kernel.org
Cc: nios2-dev@sopc.et.ntust.edu.tw, Mike Frysinger <vapier@gentoo.org>,
        Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH] gen_init_cpio: remove leading `/' from file names
Date: Wed,  6 Oct 2010 15:13:53 +0800
Message-Id: <1286349233-31721-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.1.86.g0e460
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we extracted the generated cpio archive using "cpio -id" command,
it complained,

cpio: Removing leading `/' from member names
var/run
cpio: Removing leading `/' from member names
var/lib
cpio: Removing leading `/' from member names
var/lib/misc

It is worse with the latest "cpio" or "pax", which tries to overwrite
the host file system with the leading '/'.

So the leading '/' of file names should be removed. This is consistent
with the initramfs come with major distributions such as Fedora or
Debian, etc.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 usr/gen_init_cpio.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index b2b3c2d..59df70d 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -104,6 +104,8 @@ static int cpio_mkslink(const char *name, const char *target,
 	char s[256];
 	time_t mtime = time(NULL);
 
+	if (name[0] == '/')
+		name++;
 	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
 	       "%08X%08X%08X%08X%08X%08X%08X",
 		"070701",		/* magic */
@@ -152,6 +154,8 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 	char s[256];
 	time_t mtime = time(NULL);
 
+	if (name[0] == '/')
+		name++;
 	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
 	       "%08X%08X%08X%08X%08X%08X%08X",
 		"070701",		/* magic */
@@ -245,6 +249,8 @@ static int cpio_mknod(const char *name, unsigned int mode,
 	else
 		mode |= S_IFCHR;
 
+	if (name[0] == '/')
+		name++;
 	sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
 	       "%08X%08X%08X%08X%08X%08X%08X",
 		"070701",		/* magic */
@@ -332,6 +338,8 @@ static int cpio_mkfile(const char *name, const char *location,
 		/* data goes on last link */
 		if (i == nlinks) size = buf.st_size;
 
+		if (name[0] == '/')
+			name++;
 		namesize = strlen(name) + 1;
 		sprintf(s,"%s%08X%08X%08lX%08lX%08X%08lX"
 		       "%08lX%08X%08X%08X%08X%08X%08X",
-- 
1.7.1.86.g0e460

