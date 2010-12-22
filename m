Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0LVWhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:37:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:58410 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab0LVWhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:37:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <vagabon.xyz@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf probe: Fix wrong warning in __show_one_line() if read(1) errors happen
Date: Wed, 22 Dec 2010 20:36:36 -0200
Message-Id: <1293057396-21124-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1293057396-21124-1-git-send-email-acme@infradead.org>
References: <1293057396-21124-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <vagabon.xyz@gmail.com>

This was introduced by commit fde52dbd7f71934aba4e150f3d1d51e826a08850.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <m3y67hsr0m.fsf@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 099336e..4bde988 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -309,7 +309,7 @@ static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
 	return 1;
 error:
 	if (ferror(fp)) {
-		pr_warning("Source file is shorter than expected.\n");
+		pr_warning("File read error: %s\n", strerror(errno));
 		return -1;
 	}
 	return 0;
-- 
1.6.2.5

