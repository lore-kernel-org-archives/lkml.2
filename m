Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2FFHIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:08:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35941 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2FFHIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:08:23 -0400
Date: Wed, 6 Jun 2012 00:07:53 -0700
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-378474e4b23183002f1791b294a4440b6b7df36a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        ananth@in.ibm.com, anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, acme@infradead.org, srikar@linux.vnet.ibm.com,
        oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
        ananth@in.ibm.com, anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        acme@infradead.org, rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120531114656.23691.54223.sendpatchset@srdronam.in.ibm.com>
References: <20120531114656.23691.54223.sendpatchset@srdronam.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols:
  Check for valid dso before creating map
Git-Commit-ID: 378474e4b23183002f1791b294a4440b6b7df36a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:07:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  378474e4b23183002f1791b294a4440b6b7df36a
Gitweb:     http://git.kernel.org/tip/378474e4b23183002f1791b294a4440b6b7df36a
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Thu, 31 May 2012 17:16:56 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 May 2012 12:08:22 -0300

perf symbols: Check for valid dso before creating map

dso__new() can return NULL. Hence verify dso before creating a new map.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20120531114656.23691.54223.sendpatchset@srdronam.in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9d04dcd..3e2e5ea 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2817,8 +2817,11 @@ int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 
 struct map *dso__new_map(const char *name)
 {
+	struct map *map = NULL;
 	struct dso *dso = dso__new(name);
-	struct map *map = map__new2(0, dso, MAP__FUNCTION);
+
+	if (dso)
+		map = map__new2(0, dso, MAP__FUNCTION);
 
 	return map;
 }
