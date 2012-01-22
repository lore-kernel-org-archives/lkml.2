Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab2AVVI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 16:08:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab2AVVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 16:08:56 -0500
Date: Sun, 22 Jan 2012 13:07:22 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fd45c15f13e754f3c106427e857310f3e0813951@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        namhyung.kim@lge.com, namhyung@gmail.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1327021966-27688-1-git-send-email-namhyung.kim@lge.com>
References: <1327021966-27688-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Don't call release_callchain_buffers()
  if allocation fails
Git-Commit-ID: fd45c15f13e754f3c106427e857310f3e0813951
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 22 Jan 2012 13:07:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd45c15f13e754f3c106427e857310f3e0813951
Gitweb:     http://git.kernel.org/tip/fd45c15f13e754f3c106427e857310f3e0813951
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 20 Jan 2012 10:12:45 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Jan 2012 09:33:41 +0100

perf: Don't call release_callchain_buffers() if allocation fails

When alloc_callchain_buffers() fails, it frees all of
entries before return. In addition, calling the
release_callchain_buffers() will cause a NULL pointer
dereference since callchain_cpu_entries is not set.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1327021966-27688-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/callchain.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 057e24b..6581a04 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -115,8 +115,6 @@ int get_callchain_buffers(void)
 	}
 
 	err = alloc_callchain_buffers();
-	if (err)
-		release_callchain_buffers();
 exit:
 	mutex_unlock(&callchain_mutex);
 
