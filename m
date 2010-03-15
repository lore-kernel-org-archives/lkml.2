Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459Ab0COQ4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:56:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417Ab0COQ4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:56:03 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/2] [BUGFIX] perf probe: Fix to make offset to signed
	value
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 15 Mar 2010 13:02:28 -0400
Message-ID: <20100315170228.31852.71946.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to make dereference offset intmax_t from uintmax_t, because
it can be minus value (e.g. local variable's offset from frame
pointer).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 tools/perf/util/probe-finder.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index f9cbbf1..0e8c8f1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -333,8 +333,8 @@ static void show_location(Dwarf_Op *op, struct probe_finder *pf)
 		die("%u exceeds max register number.", regn);
 
 	if (deref)
-		ret = snprintf(pf->buf, pf->len, " %s=+%ju(%s)",
-			       pf->var, (uintmax_t)offs, regs);
+		ret = snprintf(pf->buf, pf->len, " %s=%+jd(%s)",
+			       pf->var, (intmax_t)offs, regs);
 	else
 		ret = snprintf(pf->buf, pf->len, " %s=%s", pf->var, regs);
 	DIE_IF(ret < 0);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
