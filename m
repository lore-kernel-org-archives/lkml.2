Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174Ab2IGGJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:09:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55135 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2IGGJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:09:32 -0400
Date: Thu, 6 Sep 2012 23:09:13 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@gmail.com>
Message-ID: <tip-60ff92f515a4efb36931f1b5b042332016e0f123@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
In-Reply-To: <CANg8OW+Y3ZMG-GdhYu2_yKOYH_XEMgw73PdCX_23UTnfYhmttA@mail.gmail.com>
References: <CANg8OW+Y3ZMG-GdhYu2_yKOYH_XEMgw73PdCX_23UTnfYhmttA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Replace mempcpy with memcpy
Git-Commit-ID: 60ff92f515a4efb36931f1b5b042332016e0f123
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:09:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60ff92f515a4efb36931f1b5b042332016e0f123
Gitweb:     http://git.kernel.org/tip/60ff92f515a4efb36931f1b5b042332016e0f123
Author:     Irina Tirdea <irina.tirdea@gmail.com>
AuthorDate: Wed, 29 Aug 2012 01:22:16 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 19:35:21 -0300

perf tools: Replace mempcpy with memcpy

mempcpy is not supported by bionic in Android and will lead to
compilation errors.

Replacing mempcpy with memcpy so it will work in Android.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/CANg8OW+Y3ZMG-GdhYu2_yKOYH_XEMgw73PdCX_23UTnfYhmttA@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/target.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 051eaa6..065528b 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -117,8 +117,8 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 
 		if (err != buf) {
 			size_t len = strlen(err);
-			char *c = mempcpy(buf, err, min(buflen - 1, len));
-			*c = '\0';
+			memcpy(buf, err, min(buflen - 1, len));
+			*(buf + min(buflen - 1, len)) = '\0';
 		}
 
 		return 0;
