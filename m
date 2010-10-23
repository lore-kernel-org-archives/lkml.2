Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab0JWU2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 16:28:42 -0400
Received: from canuck.infradead.org ([134.117.69.58]:45564 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247Ab0JWU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 16:28:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 5/5] perf probe: Fix format specified for Dwarf_Off parameter
Date: Sat, 23 Oct 2010 18:28:24 -0200
Message-Id: <1287865704-3880-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1287865704-3880-1-git-send-email-acme@infradead.org>
References: <1287865704-3880-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Fixing the following error on 32-bit arches:

util/probe-finder.c: In function ‘line_range_search_cb’:
util/probe-finder.c:1734: error: format ‘%lx’ expects type ‘long
unsigned int’, but argument 3 has type ‘Dwarf_Off’

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c20bd52..3991d73 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1731,7 +1731,8 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	struct line_finder *lf = param->data;
 	struct line_range *lr = lf->lr;
 
-	pr_debug("find (%lx) %s\n", dwarf_dieoffset(sp_die),
+	pr_debug("find (%llx) %s\n",
+		 (unsigned long long)dwarf_dieoffset(sp_die),
 		 dwarf_diename(sp_die));
 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
 	    die_compare_name(sp_die, lr->function)) {
-- 
1.6.2.5

