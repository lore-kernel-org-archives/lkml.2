Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab0CPV27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:28:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:38283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011Ab0CPV24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:28:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf top: Add missing initialization to zero
Date: Tue, 16 Mar 2010 18:28:46 -0300
Message-Id: <1268774926-27488-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The dso_short_width has to start as zero, as we're calculating the
maximum short DSO name length, somehow I missed this one.

Reported-by: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 057f8b6..887ebbf 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -464,7 +464,7 @@ static void print_sym_table(void)
 	struct sym_entry *syme, *n;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *nd;
-	int sym_width = 0, dso_width = 0, dso_short_width;
+	int sym_width = 0, dso_width = 0, dso_short_width = 0;
 	const int win_width = winsize.ws_col - 1;
 
 	samples = userspace_samples = exact_samples = 0;
-- 
1.6.2.5

