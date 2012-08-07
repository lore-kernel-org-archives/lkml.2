Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2HGCZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:25:32 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52838 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2HGCZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:25:25 -0400
From: Palmer Cox <p@lmercox.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, Palmer Cox <p@lmercox.com>
Subject: [PATCH 3/6] cpupower tools: Fix minor warnings
Date: Mon,  6 Aug 2012 22:24:45 -0400
Message-Id: <1344306288-12369-4-git-send-email-p@lmercox.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344306288-12369-1-git-send-email-p@lmercox.com>
References: <1344306288-12369-1-git-send-email-p@lmercox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix minor warnings reported with GCC 4.6:
* The sysfs_write_file function is unused - remove it.
* The pr_mon_len in the print_header function is unsed - remove it.
---
 tools/power/cpupower/utils/helpers/sysfs.c         |   19 -------------------
 .../cpupower/utils/idle_monitor/cpupower-monitor.c |    3 +--
 2 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/tools/power/cpupower/utils/helpers/sysfs.c b/tools/power/cpupower/utils/helpers/sysfs.c
index 96e28c1..38ab916 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.c
+++ b/tools/power/cpupower/utils/helpers/sysfs.c
@@ -37,25 +37,6 @@ unsigned int sysfs_read_file(const char *path, char *buf, size_t buflen)
 	return (unsigned int) numread;
 }
 
-static unsigned int sysfs_write_file(const char *path,
-				     const char *value, size_t len)
-{
-	int fd;
-	ssize_t numwrite;
-
-	fd = open(path, O_WRONLY);
-	if (fd == -1)
-		return 0;
-
-	numwrite = write(fd, value, len);
-	if (numwrite < 1) {
-		close(fd);
-		return 0;
-	}
-	close(fd);
-	return (unsigned int) numwrite;
-}
-
 /*
  * Detect whether a CPU is online
  *
diff --git a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
index 0d6571e..7a657f3 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
@@ -84,7 +84,7 @@ int fill_string_with_spaces(char *s, int n)
 void print_header(int topology_depth)
 {
 	int unsigned mon;
-	int state, need_len, pr_mon_len;
+	int state, need_len;
 	cstate_t s;
 	char buf[128] = "";
 	int percent_width = 4;
@@ -93,7 +93,6 @@ void print_header(int topology_depth)
 	printf("%s|", buf);
 
 	for (mon = 0; mon < avail_monitors; mon++) {
-		pr_mon_len = 0;
 		need_len = monitors[mon]->hw_states_num * (percent_width + 3)
 			- 1;
 		if (mon != 0) {
-- 
1.7.9.5

