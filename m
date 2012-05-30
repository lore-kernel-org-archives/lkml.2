Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2E3AMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 20:12:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab2E3ALl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 20:11:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf ui: Make --stdio default when TUI is not supported
Date: Tue, 29 May 2012 21:11:26 -0300
Message-Id: <1338336688-25616-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338336688-25616-1-git-send-email-acme@infradead.org>
References: <1338336688-25616-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The commit dc41b9b8f02db ("perf ui: Change fallback policy of
setup_browser") changed default behavior of the function but missed
setting the use_browser variable to 0 accidently. So perf report ends up
doing nothing in such cases. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1338216802-5675-1-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 9f5f888..791fb15 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -22,6 +22,7 @@ void setup_browser(bool fallback_to_pager)
 			break;
 		/* fall through */
 	default:
+		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
 		break;
-- 
1.7.9.2.358.g22243

