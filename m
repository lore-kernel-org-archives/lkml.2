Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1JTNGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:06:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53547 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab1JTNGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:06:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf hists browser: Honour symbol_conf.show_{nr_samples,total_period}
Date: Thu, 20 Oct 2011 11:05:45 -0200
Message-Id: <1319115948-12060-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319115948-12060-1-git-send-email-acme@infradead.org>
References: <1319115948-12060-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We lost that when we move it outside hist_entry__snprintf, but better
leave it untangled of 'perf diff' stuff (pair_hist, etc).

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qlhb6ictf5twykog6x344s0b@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index d762875..9e23bce 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -577,6 +577,16 @@ static int hist_browser__show_entry(struct hist_browser *self,
 		if (!current_entry || !self->b.navkeypressed)
 			ui_browser__set_color(&self->b, HE_COLORSET_NORMAL);
 
+		if (symbol_conf.show_nr_samples) {
+			slsmg_printf(" %11u", entry->nr_events);
+			width -= 12;
+		}
+
+		if (symbol_conf.show_total_period) {
+			slsmg_printf(" %12" PRIu64, entry->period);
+			width -= 13;
+		}
+
 		slsmg_write_nstring(s, width);
 		++row;
 		++printed;
-- 
1.6.2.5

