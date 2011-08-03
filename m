Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1HCFRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 01:17:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab1HCFRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 01:17:31 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <amwang@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Subject: [Patch] cpupower: avoid using symlinks
Date: Wed,  3 Aug 2011 13:17:01 +0800
Message-Id: <1312348621-20172-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference the source directly, don't create symlinks.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/tools/power/cpupower/debug/x86_64/Makefile b/tools/power/cpupower/debug/x86_64/Makefile
index dbf1399..3326217 100644
--- a/tools/power/cpupower/debug/x86_64/Makefile
+++ b/tools/power/cpupower/debug/x86_64/Makefile
@@ -1,10 +1,10 @@
 default: all
 
-centrino-decode: centrino-decode.c
-	$(CC) $(CFLAGS) -o centrino-decode centrino-decode.c
+centrino-decode: ../i386/centrino-decode.c
+	$(CC) $(CFLAGS) -o $@ $<
 
-powernow-k8-decode: powernow-k8-decode.c
-	$(CC) $(CFLAGS) -o powernow-k8-decode powernow-k8-decode.c
+powernow-k8-decode: ../i386/powernow-k8-decode.c
+	$(CC) $(CFLAGS) -o $@ $<
 
 all: centrino-decode powernow-k8-decode
 
diff --git a/tools/power/cpupower/debug/x86_64/centrino-decode.c b/tools/power/cpupower/debug/x86_64/centrino-decode.c
deleted file mode 120000
index 26fb3f1..0000000
--- a/tools/power/cpupower/debug/x86_64/centrino-decode.c
+++ /dev/null
@@ -1 +0,0 @@
-../i386/centrino-decode.c
\ No newline at end of file
diff --git a/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c b/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
deleted file mode 120000
index eb30c79..0000000
--- a/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
+++ /dev/null
@@ -1 +0,0 @@
-../i386/powernow-k8-decode.c
\ No newline at end of file
