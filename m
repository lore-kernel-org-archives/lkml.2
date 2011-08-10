Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1HJI0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:26:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:50520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HJI0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:26:02 -0400
Date: Wed, 10 Aug 2011 08:25:43 GMT
From: tip-bot for Zhu Yanhai <zhu.yanhai@gmail.com>
Message-ID: <tip-cf8dc9ff29b55955197ae6f628b19f7f41f6e582@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, zhu.yanhai@gmail.com, gaoyang.zyh@taobao.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, zhu.yanhai@gmail.com, gaoyang.zyh@taobao.com,
        mingo@elte.hu
In-Reply-To: <1312035232-9534-1-git-send-email-gaoyang.zyh@taobao.com>
References: <1312035232-9534-1-git-send-email-gaoyang.zyh@taobao.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf lock: Dropping unsupported ':r' modifier
Git-Commit-ID: cf8dc9ff29b55955197ae6f628b19f7f41f6e582
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 08:25:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf8dc9ff29b55955197ae6f628b19f7f41f6e582
Gitweb:     http://git.kernel.org/tip/cf8dc9ff29b55955197ae6f628b19f7f41f6e582
Author:     Zhu Yanhai <zhu.yanhai@gmail.com>
AuthorDate: Sat, 30 Jul 2011 22:13:52 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Aug 2011 09:41:35 -0300

perf lock: Dropping unsupported ':r' modifier

Looks to me like the :r modifier is not supported anymore, so remove it
from the list of events. Without this fix 'perf lock record' doesn't
work.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Zhu Yanhai <gaoyang.zyh@taobao.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1312035232-9534-1-git-send-email-gaoyang.zyh@taobao.com
Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
