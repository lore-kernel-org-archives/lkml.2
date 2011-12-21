Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1LUIpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:45:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1LUIpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:45:03 -0500
Date: Wed, 21 Dec 2011 00:44:36 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-d74c896b7e3250a07f7d0315eecdd2ae1a7bc3c3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1323703017-6060-4-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-4-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Fix error path on symbol__init()
Git-Commit-ID: d74c896b7e3250a07f7d0315eecdd2ae1a7bc3c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:44:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d74c896b7e3250a07f7d0315eecdd2ae1a7bc3c3
Gitweb:     http://git.kernel.org/tip/d74c896b7e3250a07f7d0315eecdd2ae1a7bc3c3
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 13 Dec 2011 00:16:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 13:40:27 -0200

perf symbols: Fix error path on symbol__init()

The order of freeing comm_list and dso_list should be reversed.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323703017-6060-4-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e54b13d..215d50f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2604,10 +2604,10 @@ int symbol__init(void)
 	symbol_conf.initialized = true;
 	return 0;
 
-out_free_dso_list:
-	strlist__delete(symbol_conf.dso_list);
 out_free_comm_list:
 	strlist__delete(symbol_conf.comm_list);
+out_free_dso_list:
+	strlist__delete(symbol_conf.dso_list);
 	return -1;
 }
 
