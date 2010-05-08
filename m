Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0EHIKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:10:10 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:57309 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0EHIKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:10:07 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH] perf lock: Drop "-a" option from set of default arguments to cmd_record()
Date: Sat,  8 May 2010 17:10:29 +0900
Message-Id: <1273306229-5216-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4BE51A90.2060305@dcl.info.waseda.ac.jp>
References: <4BE51A90.2060305@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch drops "-a" from record_args, which is passed to cmd_record().

Even if user wants to record all lock events during process runs,
        perf lock record -a <program> <argument> ...
is enough for this purpose.

This can reduce size of perf.data.

% sudo ./perf lock record whoami
root
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.439 MB perf.data (~19170 samples) ]
% sudo ./perf lock record -a whoami   # with -a option
root
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 48.962 MB perf.data (~2139197 samples) ]

This patch was made on perf/test of random-tracing.git,
could you queue this, Frederic?

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

---
 tools/perf/builtin-lock.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index d7dde9c..7f72abc 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -930,7 +930,6 @@ static const struct option lock_options[] = {
 
 static const char *record_args[] = {
 	"record",
-	"-a",
 	"-R",
 	"-f",
 	"-m", "1024",
-- 
1.6.5.2

