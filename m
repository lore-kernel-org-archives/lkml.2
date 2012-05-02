Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab2EBRnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:43:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab2EBRnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:43:42 -0400
Date: Wed, 2 May 2012 10:43:15 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-afda0f94483f46a4caddb529b8f95e0aaf015de6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1335881976-3282-1-git-send-email-namhyung@gmail.com>
References: <1335881976-3282-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf build-id: Fix filename size calculation
Git-Commit-ID: afda0f94483f46a4caddb529b8f95e0aaf015de6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 02 May 2012 10:43:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afda0f94483f46a4caddb529b8f95e0aaf015de6
Gitweb:     http://git.kernel.org/tip/afda0f94483f46a4caddb529b8f95e0aaf015de6
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 1 May 2012 23:19:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 1 May 2012 14:13:00 -0300

perf build-id: Fix filename size calculation

The filename is a pointer variable so the sizeof(filename) will return
length of a pointer. Fix it by using 'size'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335881976-3282-1-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c7c2d7..c0b70c6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -296,7 +296,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
-	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
+	snprintf(filename + len, size - len, "/%s", sbuild_id);
 
 	if (access(filename, F_OK)) {
 		if (is_kallsyms) {
