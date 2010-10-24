Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab0JXJoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:44:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:56034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333Ab0JXJoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:44:07 -0400
Date: Sun, 24 Oct 2010 09:43:42 GMT
From: tip-bot for Ben Hutchings <ben@decadent.org.uk>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        ben@decadent.org.uk, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        ben@decadent.org.uk, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1286723462.2955.206.camel@localhost>
References: <1286723462.2955.206.camel@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Fix detection of script extension
Message-ID: <tip-d1e95bb5309f98368dd4fbef6ff3a8f573b24506@git.kernel.org>
Git-Commit-ID: d1e95bb5309f98368dd4fbef6ff3a8f573b24506
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 24 Oct 2010 09:43:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1e95bb5309f98368dd4fbef6ff3a8f573b24506
Gitweb:     http://git.kernel.org/tip/d1e95bb5309f98368dd4fbef6ff3a8f573b24506
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Sun, 10 Oct 2010 16:11:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 23 Oct 2010 15:31:20 -0200

perf trace: Fix detection of script extension

The extension starts with the last dot in the name, not the first.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286723462.2955.206.camel@localhost>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3ea6219..deda1a9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -282,7 +282,7 @@ static int parse_scriptname(const struct option *opt __used,
 		script++;
 	} else {
 		script = str;
-		ext = strchr(script, '.');
+		ext = strrchr(script, '.');
 		if (!ext) {
 			fprintf(stderr, "invalid script extension");
 			return -1;
