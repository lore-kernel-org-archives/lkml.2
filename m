Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1G3OOL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 10:14:11 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56698 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1G3OOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 10:14:08 -0400
From: Zhu Yanhai <zhu.yanhai@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>
Subject: [PATCH] perf lock: dropping unsupported ':r' modifier
Date: Sat, 30 Jul 2011 22:13:52 +0800
Message-Id: <1312035232-9534-1-git-send-email-gaoyang.zyh@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks to me like the :r modifier is not supported anymore, so remove it from
the list of events. Without this fix 'perf lock record' doesn't work.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
---
 tools/perf/builtin-lock.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 9ac05aa..899080a 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -942,10 +942,10 @@ static const char *record_args[] = {
 	"-f",
 	"-m", "1024",
 	"-c", "1",
-	"-e", "lock:lock_acquire:r",
-	"-e", "lock:lock_acquired:r",
-	"-e", "lock:lock_contended:r",
-	"-e", "lock:lock_release:r",
+	"-e", "lock:lock_acquire",
+	"-e", "lock:lock_acquired",
+	"-e", "lock:lock_contended",
+	"-e", "lock:lock_release",
 };
 
 static int __cmd_record(int argc, const char **argv)
-- 
1.5.5.6

