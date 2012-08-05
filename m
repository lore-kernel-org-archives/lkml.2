Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2HEQod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:44:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56714 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:44:31 -0400
Date: Sun, 5 Aug 2012 09:44:10 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-028df76726c5637c6f70a064d94452808ec74f9e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, markus@trippelsdorf.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, markus@trippelsdorf.de, tglx@linutronix.de
In-Reply-To: <1343825277-10517-1-git-send-email-jolsa@redhat.com>
References: <1343825277-10517-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols:
  Fix array sizes for binary types arrays
Git-Commit-ID: 028df76726c5637c6f70a064d94452808ec74f9e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:44:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  028df76726c5637c6f70a064d94452808ec74f9e
Gitweb:     http://git.kernel.org/tip/028df76726c5637c6f70a064d94452808ec74f9e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 1 Aug 2012 14:47:57 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Aug 2012 18:42:22 -0300

perf symbols: Fix array sizes for binary types arrays

Following commit introduced wrong array boundaries, that could lead to
SIGSEGV.

  perf symbols: Factor DSO symtab types to generic binary types
  commit 44f24cb3156a1e7d2b6bb501b7f6153aed08994c
  Author: Jiri Olsa <jolsa@redhat.com>

Fixing to use proper array size.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Link: http://lkml.kernel.org/r/1343825277-10517-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fdad4eee..fe86612 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -64,7 +64,7 @@ static enum dso_binary_type binary_type_symtab[] = {
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
-#define DSO_BINARY_TYPE__SYMTAB_CNT sizeof(binary_type_symtab)
+#define DSO_BINARY_TYPE__SYMTAB_CNT ARRAY_SIZE(binary_type_symtab)
 
 static enum dso_binary_type binary_type_data[] = {
 	DSO_BINARY_TYPE__BUILD_ID_CACHE,
@@ -72,7 +72,7 @@ static enum dso_binary_type binary_type_data[] = {
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
-#define DSO_BINARY_TYPE__DATA_CNT sizeof(binary_type_data)
+#define DSO_BINARY_TYPE__DATA_CNT ARRAY_SIZE(binary_type_data)
 
 int dso__name_len(const struct dso *dso)
 {
