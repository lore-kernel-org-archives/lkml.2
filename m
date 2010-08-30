Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0H3IeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:34:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:54088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab0H3IeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:34:22 -0400
Date: Mon, 30 Aug 2010 08:33:52 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Fix hist_entry__init_have_children
Message-ID: <tip-18b308d7994e0e2a360b979f159fa7d2b91a26b1@git.kernel.org>
Git-Commit-ID: 18b308d7994e0e2a360b979f159fa7d2b91a26b1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 08:33:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18b308d7994e0e2a360b979f159fa7d2b91a26b1
Gitweb:     http://git.kernel.org/tip/18b308d7994e0e2a360b979f159fa7d2b91a26b1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 25 Aug 2010 12:47:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Aug 2010 14:39:09 -0300

perf hists: Fix hist_entry__init_have_children

It wasn't setting the ms.has_children for the hist_entry itself, just
for the callchain

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index b13b978..39ba230 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -168,6 +168,7 @@ static void callchain__init_have_children(struct rb_root *self)
 static void hist_entry__init_have_children(struct hist_entry *self)
 {
 	if (!self->init_have_children) {
+		self->ms.has_children = !RB_EMPTY_ROOT(&self->sorted_chain);
 		callchain__init_have_children(&self->sorted_chain);
 		self->init_have_children = true;
 	}
