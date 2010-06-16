Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0FPFYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:24:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64000 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab0FPFYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:24:12 -0400
Message-ID: <4C185F68.1020505@cn.fujitsu.com>
Date: Wed, 16 Jun 2010 13:21:44 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: mingo@elte.hu
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: excluding "." and ".." directories when calculating
 tids.
References: <4C1740B1.9070806@cn.fujitsu.com> <4C1748D6.1020007@cn.fujitsu.com>
In-Reply-To: <4C1748D6.1020007@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a filter function to skip "." and ".." directories when calculating
tid number.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 tools/perf/util/thread.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 1f7ecd4..9a448b4 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,6 +7,15 @@
 #include "util.h"
 #include "debug.h"
 
+/* Skip "." and ".." directories */
+static int filter(const struct dirent *dir)
+{
+	if (dir->d_name[0] == '.')
+		return 0;
+	else
+		return 1;
+}
+
 int find_all_tid(int pid, pid_t ** all_tid)
 {
 	char name[256];
@@ -16,7 +25,7 @@ int find_all_tid(int pid, pid_t ** all_tid)
 	int i;
 
 	sprintf(name, "/proc/%d/task", pid);
-	items = scandir(name, &namelist, NULL, NULL);
+	items = scandir(name, &namelist, filter, NULL);
 	if (items <= 0)
                 return -ENOENT;
 	*all_tid = malloc(sizeof(pid_t) * items);
-- 
1.6.5.2

