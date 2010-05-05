Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897Ab0EEObK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:31:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:33920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab0EEObF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:31:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/4] perf report: Make dso__calc_col_width agree with hist_entry__dso_snprintf
Date: Wed,  5 May 2010 11:30:45 -0300
Message-Id: <1273069848-22934-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273069848-22934-1-git-send-email-acme@infradead.org>
References: <1273069848-22934-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The first was always using the ->long_name, while the later used
->short_name if verbose was not set, resulting in the dso column to be
much wider than needed most of the time.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2477270..23d5dfd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -626,8 +626,10 @@ static void dso__calc_col_width(struct dso *self)
 	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
 	    (!symbol_conf.dso_list ||
 	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
-		unsigned int slen = strlen(self->name);
-		if (slen > dsos__col_width)
+		u16 slen = self->short_name_len;
+		if (verbose)
+			slen = self->long_name_len;
+		if (dsos__col_width < slen)
 			dsos__col_width = slen;
 	}
 
-- 
1.6.2.5

