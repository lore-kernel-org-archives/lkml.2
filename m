Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1CYVpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:45:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:33712 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1CYVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:45:01 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dan Carpenter <error27@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/4] kgdboc,kgdbts: strlen() doesn't count the terminator
Date: Fri, 25 Mar 2011 16:44:17 -0500
Message-Id: <1301089460-1936-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
References: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Mar 2011 21:44:21.0816 (UTC) FILETIME=[CD2B6B80:01CBEB35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

This is an off by one because strlen() doesn't count the null
terminator.  We strcpy() these strings into an array of size
MAX_CONFIG_LEN.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c       |    2 +-
 drivers/tty/serial/kgdboc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 59c118c..27dc463 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -988,7 +988,7 @@ static void kgdbts_run_tests(void)
 
 static int kgdbts_option_setup(char *opt)
 {
-	if (strlen(opt) > MAX_CONFIG_LEN) {
+	if (strlen(opt) >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdbts: config string too long\n");
 		return -ENOSPC;
 	}
diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
index 25a8bc5..87e7e6c 100644
--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -131,7 +131,7 @@ static void kgdboc_unregister_kbd(void)
 
 static int kgdboc_option_setup(char *opt)
 {
-	if (strlen(opt) > MAX_CONFIG_LEN) {
+	if (strlen(opt) >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdboc: config string too long\n");
 		return -ENOSPC;
 	}
-- 
1.7.1

